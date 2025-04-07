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

protocol CurrencyConverterViewModelProtocol {
    func getDolar() async throws -> DolarBlue?
    func checkPermission(dolar: String)
    func getTextForPicker(row: Int) -> String
    func resetCurrency()
    func getCurrencyArray() -> [String]
    func updateCurrency(currency: String)
    func updateAmount(_ amount: Double?)
    func getConvertedValues() -> AnyPublisher<(String, String, String, String), Never> 
}


class CurrencyConverterViewModel: CurrencyConverterViewModelProtocol{
    
    var currency : Rates = Rates(BRL: Brl(rate: nil), CLP: Clp(rate: nil), UYU: Uyu(rate: nil))
    //private(set) var dolar : ExchangeRate?
    
    var currencyArray = ["BRL","CLP","UYU"]
    weak var delegate: CurrencyViewModelDelegate?
    var amountSubject = CurrentValueSubject<Double?,Never>(nil)
    var currencySubject =  CurrentValueSubject<String?, Never>(nil)
    var cancellables = Set<AnyCancellable>()
    var currencyFromPeso : String = ""
    var currencyToPeso : String = ""
    var pesoToDolar : String = ""
    var currencyToDolarValue : String = ""

    
    let currencyUrl = "https://api.getgeoapi.com/v2/currency/convert?api_key="
    let apiKey = "99f81f10b5b6b92679b9051bdce40b7647f150e0"
    
    private let currencyService: CurrencyServiceProtocol
    private let notificationService: NotificationServiceProtocol
    
    init(currencyService: CurrencyServiceProtocol, notificationService: NotificationServiceProtocol) {
        self.currencyService = currencyService
        self.notificationService = notificationService
        
        Task { try await fetchExchangeRates() }
    }
    
    func getCurrencyArray() -> [String] {
        return currencyArray
    }

    @MainActor
    func fetchExchangeRates() async throws -> Rates{
       // return currencyService.fetchExchangeRates()
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
    }
    
    @MainActor
    func getDolar() async throws -> DolarBlue?{
        return try await currencyService.getDolarBlue()
    }
    
    func checkPermission(dolar: String){
        return notificationService.checkPermission(dolar: dolar)
    }
    
    func getTextForPicker(row: Int) -> String {
        switch row {
        case 0: return "Real Brasil"
        case 1: return "Peso Chile"
        case 2: return "Peso Uruguay"
        default: return "error"
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
    
    func getConvertedValues() -> AnyPublisher<(String, String, String, String), Never> {
        return convertedValues
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

}

//MARK: - Binding Methods

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
                    let dolar = try await self.getDolar()
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
    
    func convertDolar(quantity: Double) async throws -> String {
        let maxRetries = 3
        var retries = 0
        var dolarValue: Double = 0.0
        
        while retries < maxRetries {
            if let exchangeRate = try await getDolar() {
                dolarValue = exchangeRate.venta
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
}


