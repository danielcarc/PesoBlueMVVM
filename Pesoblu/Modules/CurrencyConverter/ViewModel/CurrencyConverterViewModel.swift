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
    func getDolarBlue() async throws -> DolarBlue?
    func checkPermission(dolar: String)
    func getCurrencyArray() -> [String]
    func updateCurrency(selectedCurrency: CurrencyItem)
    func updateAmount(_ amount: Double?)
    func getConvertedValues() -> AnyPublisher<(String, String, String, String), Never> 
}


final class CurrencyConverterViewModel: CurrencyConverterViewModelProtocol{
    
    var currency : Rates = Rates()
    var dolarMep: DolarMEP?
    var selectedCurrency: CurrencyItem
    
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
    
    init(currencyService: CurrencyServiceProtocol, notificationService: NotificationServiceProtocol, selectedCurrency: CurrencyItem) {
        self.currencyService = currencyService
        self.notificationService = notificationService
        self.selectedCurrency = selectedCurrency
        
        Task {
            do {
                try await fetchExchangeRates()
                try await getDolarMEP()
            } catch {
                AppLogger.error("Error al obtener los datos: \(error.localizedDescription)")
                // Podés notificar al delegate también si querés:
                // delegate?.didFail(error: error)
            }
        }
    }
    
    func getCurrencyArray() -> [String] {
        return currencyArray
    }

    // MARK: - Public - API

    @MainActor
    func fetchExchangeRates() async throws {
        guard let url = URL(string: "\(currencyUrl)\(apiKey)&from=USD&to=BRL,UYU,CLP,EUR,GBP,COP,JPY,ILS,MXN,PYG,PEN,RUB,CAD,BOB&format=json")
        else { throw APIError.invalidURL }

        let rates: Rates = try await Task.detached(priority: .userInitiated) {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(CurrencyResponse.self, from: data).rates
        }.value
        
        self.currency = rates
    }

    func getDolarBlue() async throws -> DolarBlue? {
        try await currencyService.getDolarBlue()
    }

    @MainActor
    func getDolarMEP() async throws {
        let mep = try await currencyService.getDolarMep()
        self.dolarMep = mep
    }
    
    func checkPermission(dolar: String){
        return notificationService.checkPermission(dolar: dolar)
    }
    
    // MARK: - Private Methods

    func updateAmount(_ amount: Double?){
        amountSubject.send(amount)
    }
    func updateCurrency(selectedCurrency: CurrencyItem){
        self.selectedCurrency = selectedCurrency
        currencySubject.send(selectedCurrency.rate)
    }
    
    func getConvertedValues() -> AnyPublisher<(String, String, String, String), Never> {
        return convertedValues
    }
    
    lazy var convertedValues: AnyPublisher<(String, String, String, String), Never> = {
        currencySubject
            .drop(while: { $0 == nil }) // Ignora valores nil
            .combineLatest(amountSubject)
            .debounce(for: .milliseconds(150), scheduler: DispatchQueue.main)
            .filter { currency, amount in
                amount != nil && currency != nil
            }
            .flatMap { [weak self] (currency, amount) -> AnyPublisher<(String, String, String, String), Never> in
                guard let self = self,
                      let amount = amount,
                      let currency = currency else {
                    return Just(("", "", "", "")).eraseToAnyPublisher()
                }
                return self.fetchConversionRates(amount: amount, fromCurrency: currency)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()

}

    // MARK: - Binding Methods

extension CurrencyConverterViewModel {
    //enviar valores para los 4 posibles valores y para el segmentedcontrol y ahi ver
    private func fetchConversionRates(amount: Double, fromCurrency: String) -> AnyPublisher<(String, String, String, String), Never> {
        Future { [weak self] promise in
            guard let self = self else {
                promise(.success(("", "", "", "")))
                return
            }
            let dolar = self.dolarMep
            let dolarValue = dolar?.venta ?? 0.0
            let currencyValue = Double(self.selectedCurrency.rate ?? "0.0") ?? 0.0
            
            if self.selectedCurrency.currencyTitle == "USD MEP - Dólar Americano" {
                let fromDolarCurrency = String(format: "%.2f", amount * currencyValue)
                let currencyFromPeso = String(format: "%.2f", amount / currencyValue)  
                let currencyToPeso = String(format: "%.2f", amount * currencyValue)
                let currencyToDolarValue = String(format: "%.2f", amount / currencyValue)
                promise(.success((currencyFromPeso, currencyToPeso, fromDolarCurrency, currencyToDolarValue)))
            }
            else{
                let currencyInDolarValue = dolarValue / currencyValue
                
                let fromDolarCurrency = String(format: "%.2f", amount * currencyInDolarValue)
                let currencyFromPeso = String(format: "%.2f", (amount / dolarValue) * currencyInDolarValue)
                let currencyToPeso = String(format: "%.2f", (amount / currencyInDolarValue) * dolarValue)
                let currencyToDolarValue = String(format: "%.2f", amount / currencyInDolarValue)
                promise(.success((currencyFromPeso, currencyToPeso, fromDolarCurrency, currencyToDolarValue)))
            }
        }
        .eraseToAnyPublisher()
    }
    
}
