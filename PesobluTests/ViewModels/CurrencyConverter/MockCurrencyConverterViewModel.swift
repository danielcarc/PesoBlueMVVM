//
//  MockCurrencyConverterViewModel.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 31/03/2025.
//

import Combine
@testable import Pesoblu

class MockCurrencyConverterViewModel: CurrencyConverterViewModelProtocol {
    func updateCurrency(selectedCurrency: any Pesoblu.CurrencyItem) {
        ""
    }
    
    
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
    
    func getDolarBlue() async throws -> DolarBlue? {
        return try await currencyService.getDolarBlue()
    }
    
    func checkPermission(dolar: String) {
        notificationService.checkPermission(dolar: dolar)
    }
    
    func getTextForPicker(row: Int) -> String {
        _ = ["BRL", "CLP", "UYU"]
        switch row {
        case 0: return "Real Brasil"
        case 1: return "Peso Chile"
        case 2: return "Peso Uruguay"
        default: return "error"
        }
    }
    
    func resetCurrency(){
        selectedCurrency = "BRL"
        updateMockValues()
    }
    
    func getCurrencyArray() -> [String] {
        return ["BRL", "CLP", "UYU"]
    }
    
    func convertDolar(quantity: Double) async throws -> String {
        guard let dolarValue = try await (currencyService as? MockCurrencyService)?.getDolarMep(), dolarValue.venta > 0 else {
            throw ConversionError.invalidDollarRate
        }
        let result = quantity / dolarValue.venta
        return String(format: "%.2f", result)
    }
    
    private func updateMockValues() {
        guard let dolarValue = (currencyService as? MockCurrencyService)?.mockDolarMep, dolarValue.venta > 0 else {
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
        
        let pesoToDolar = amount / dolarValue.venta // 450 / 900 = 0.5
        let currencyFromPeso = (amount / dolarValue.venta) * currencyValue // 450 / 900 * 5.0 = 2.5
        let currencyToPeso = (amount / currencyValue) * dolarValue.venta  // 450 / 5 * 900 = 81000
        let currencyToDolarValue = amount / currencyValue // 450 / 5 = 90
        
        convertedValuesSubject.send((
            String(format: "%.2f", currencyFromPeso),
            String(format: "%.2f", currencyToPeso),
            String(format: "%.2f", pesoToDolar),
            String(format: "%.2f", currencyToDolarValue)
        ))
    }
}
