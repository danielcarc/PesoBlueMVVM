//
//  MockCurrencyConverterViewModel.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 31/03/2025.
//

import Combine
@testable import Pesoblu

class MockCurrencyConverterViewModel: CurrencyConverterViewModelProtocol {
    
    private let currencyService: CurrencyServiceProtocol
    private let notificationService: NotificationServiceProtocol
    private var amount: Double = 0.0
    private var selectedCurrency: String = "BRL"
    
    // Usamos CurrentValueSubject en lugar de una variable estática
    private let convertedValuesSubject = CurrentValueSubject<(String, String, String, String), Never>(("", "", "", ""))
    
    init(currencyService: CurrencyServiceProtocol, notificationService: NotificationServiceProtocol) {
        self.currencyService = currencyService
        self.notificationService = notificationService
    }
    
    func getConvertedValues() -> AnyPublisher<(String, String, String, String), Never> {
        convertedValuesSubject.eraseToAnyPublisher()
    }
    
    func updateAmount(_ amount: Double?) {
        self.amount = amount!
        updateMockValues()
    }
    
    func updateCurrency(currency: String) {
        self.selectedCurrency = currency
        updateMockValues()
    }
    
    func getDolar() async throws -> DolarBlue? {
        return try await currencyService.getDolarBlue()
    }
    
    func checkPermission(dolar: String) {
        notificationService.checkPermission(dolar: dolar)
    }
    
    func getTextForPicker(row: Int) -> String {
        let currencyArray = ["BRL", "CLP", "UYU"]
        switch row {
        case 0: return "Real Brasil"
        case 1: return "Peso Chile"
        case 2: return "Peso Uruguay"
        default: return "error"
        }
    }
    
    func resetCurrency() {
        selectedCurrency = "BRL"
        updateMockValues()
    }
    
    func getCurrencyArray() -> [String] {
        return ["BRL", "CLP", "UYU"]
    }
    
    func convertDolar(quantity: Double) async throws -> String {
        guard let dolarValue = (currencyService as? MockCurrencyService)?.dolarValue, dolarValue > 0 else {
            throw ConversionError.invalidDollarRate
        }
        let result = quantity / dolarValue
        return String(format: "%.2f", result)
    }
    
    private func updateMockValues() {
        guard let dolarValue = (currencyService as? MockCurrencyService)?.dolarValue, dolarValue > 0 else {
            convertedValuesSubject.send(("0.00", "0.00", "0.00", "0.00"))
            return
        }
        
        let currencyValue: Double
        switch selectedCurrency {
        case "BRL": currencyValue = 5.0
        case "CLP": currencyValue = 900.0
        case "UYU": currencyValue = 40.0
        default: currencyValue = 0.0
        }
        
        let pesoToDolar = amount / dolarValue
        let currencyFromPeso = (amount / dolarValue) * currencyValue
        let currencyToPeso = (amount / currencyValue) * dolarValue
        let currencyToDolarValue = amount / currencyValue
        
        convertedValuesSubject.send((
            String(format: "%.2f", currencyFromPeso),
            String(format: "%.2f", currencyToPeso),
            String(format: "%.2f", pesoToDolar),
            String(format: "%.2f", currencyToDolarValue)
        ))
    }
}
