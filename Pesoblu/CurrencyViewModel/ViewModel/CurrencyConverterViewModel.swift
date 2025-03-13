//
//  ViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//


import Foundation

enum ConversionError: Error {
    case failedToFetchDollarRate
    case invalidDollarRate
}

protocol CurrencyViewModelDelegate: AnyObject{
    func didFinish() async
    func didFail(error: Error)
}

import Foundation
import UIKit
import Combine


class CurrencyConverterViewModel{
    
    private var currency : Rates = Rates(BRL: Brl(rate: nil), CLP: Clp(rate: nil), UYU: Uyu(rate: nil))
    private(set) var dolar : ExchangeRate?
    
    var currencyArray = ["BRL","CLP","UYU"]

    
    weak var delegate: CurrencyViewModelDelegate?
    
    var amountSubject = CurrentValueSubject<Double?,Never>(nil)
    var currencySubject =  CurrentValueSubject<String?, Never>(nil)
    var cancellables = Set<AnyCancellable>()

    
    let currencyUrl = "https://api.getgeoapi.com/v2/currency/convert?api_key="
    let apiKey = "99f81f10b5b6b92679b9051bdce40b7647f150e0"
    

    @MainActor
    func fetchChange() async throws -> Rates{
        guard let url = URL(string: "\(currencyUrl)\(apiKey)&from=USD&to=BRL,UYU,CLP&format=json")
        else {throw APIError.invalidURL}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let jsonDecoder = JSONDecoder()
        
        self.currency = try jsonDecoder.decode(CurrencyResponse.self, from: data).rates
        //await self.delegate?.didFinish()
        return currency
        //print(currency)
//        catch{
//            self.delegate?.didFail(error: error)
//            print(error.localizedDescription)
//        }
    }
    @MainActor
    func getDolar() async -> ExchangeRate?{
        
        do{
            guard let url = URL(string: "https://dolarapi.com/v1/dolares/blue") else {return nil}
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error en response")
                return nil
            }
            let jsonDecoder = JSONDecoder()
            self.dolar = try jsonDecoder.decode(ExchangeRate.self, from: data)
            return dolar
            
            //print(self.dolar?.venta as Any)
        }
        catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getTextForPicker(row: Int) -> String {
            switch row {
            case 0: return "Real Brasil"
            case 1: return "Peso Chile"
            case 2: return "Peso Uruguay"
            default: return "error"
            }
    }
    
    func convertDolar(quantity: Double) async throws -> String {
        let maxRetries = 3
        var retries = 0
        var dolarValue: Double = 0.0
        
        while retries < maxRetries {
            if let exchangeRate = await getDolar() {
                dolarValue = exchangeRate.venta ?? 0.0
                if dolarValue > 0 {
                    let dolarConvert = quantity / dolarValue
                    return String(format: "%.2f", dolarConvert)
                }
                // Si dolarValue es 0 o negativo, seguimos reintentando
            }
            
            retries += 1
            if retries < maxRetries {
                try await Task.sleep(for: .milliseconds(100)) // Espera 100 ms antes de reintentar
            }
        }
        
        // Si llegamos aquí, no se obtuvo un valor válido después de los reintentos
        throw dolarValue == 0.0 ? ConversionError.invalidDollarRate : ConversionError.failedToFetchDollarRate
    }
    
    func valueForCurrency(currencyText: String) -> String {
        switch currencyText {
        case "Real Brasil": return currency.BRL.rate ?? "0.0"
        case "Peso Chile": return currency.CLP.rate ?? "0.0"
        case "Peso Uruguay": return currency.UYU.rate ?? "0.0"
        default: return "0.0"
        }
    }
    
    func dispatchNotificaction(dolar: String){
        let identifier = "dolarValueNotification"
        let title = "Actualizacion del Dolar"
        let body = "El valor del Dolar es: $\(dolar)"
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        //notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request) { error in
            if let error = error{
                print(error.localizedDescription)
            }else{
                print("se deberia imprimir")
            }
        }
    }
    
    func checkPermission(dolar: String){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]){ didAllow, error in
                    if didAllow{
                        self.dispatchNotificaction(dolar: dolar)
                    }
                }
            case .denied:
                return
            case .authorized:
                self.dispatchNotificaction(dolar: dolar)
                print("permitido \(dolar)")
            default:
                return
            }
        }
    }
    
    func updateAmount(_ amount: Double?){
        amountSubject.send(amount)
    }
    func updateCurrency(currency: String){
        currencySubject.send(currency)
    }
    
    func resetCurrency() {
        currencySubject.send(nil) // Resetea la moneda
    }
    
    lazy var convertedValues: AnyPublisher<(String, String, String, String), Never> = {
        currencySubject
            .drop(while: { $0 == nil }) // Ignora valores nil
            .combineLatest(amountSubject)
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .filter { currency, amount in
                amount != nil && currency != nil
            }
            .flatMap { [weak self] (currency, amount) -> AnyPublisher<(String, String, String, String), Never> in
                guard let self = self, let amount = amount, let currency = currency else {
                    return Just(("", "", "", "")).eraseToAnyPublisher()
                }
                return self.fetchConversionRates(amount: amount, fromCurrency: currency)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()
    init() {
        Task { try await fetchChange() } // Cargar tasas iniciales
    }
    
    var currencyFromPeso : String = ""
    var currencyToPeso : String = ""
    var pesoToDolar : String = ""
    var currencyToDolarValue : String = ""
}

extension CurrencyConverterViewModel {
    //enviar valores para los 4 posibles valores y para el segmentedcontrol y ahi ver
    private func fetchConversionRates(amount: Double, fromCurrency: String) -> AnyPublisher<(String, String, String, String), Never> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.success(("", "", "", "")))
                return
            }
            Task {
                do {
                    let dolar = await self.getDolar()
                    let dolarValue = dolar?.venta ?? 0.0
                    let currencyValue = Double(self.valueForCurrency(currencyText: self.getTextForPicker(row: self.currencyArray.firstIndex(of: fromCurrency) ?? 0))) ?? 0.0
                    
                    let pesoToDolar = try await self.convertDolar(quantity: amount)
                    let currencyFromPeso = String(format: "%.2f", (amount / dolarValue) * currencyValue)
                    let currencyToPeso = String(format: "%.2f", (amount / currencyValue) * dolarValue)
                    let currencyToDolarValue = String(format: "%.2f", amount / currencyValue)
                    
                    promise(.success((currencyFromPeso, currencyToPeso, pesoToDolar, currencyToDolarValue)))
                } catch {
                    print("Error en conversión: \(error)")
                    promise(.success(("", "", "", ""))) // Valor por defecto en caso de error
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}


