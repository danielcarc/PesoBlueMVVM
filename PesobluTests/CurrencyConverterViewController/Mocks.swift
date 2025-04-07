//
//  Mocks.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 25/03/2025.
//
@testable import Pesoblu

class MockCurrencyService: CurrencyServiceProtocol {
    var dolarValue: Double? // para simular getDolarBlue
    var rates: Rates = Rates(BRL: Brl(rate: "5.0"), CLP: Clp(rate: "900.0"), UYU: Uyu(rate: "40.0")) // tasas ficticias
    
    
    func getDolarBlue() async throws -> Pesoblu.DolarBlue? {
        if let value = dolarValue {
            return Pesoblu.DolarBlue(moneda: "Moneda", casa: "casa", nombre: "moneda", compra: value - 10, venta: value, fechaActualizacion: "fecha")
        }
        return nil
    }
    
    func getValueForCountry(countryCode: String) async throws -> String {
        return ""
    }
    
    func fetchExchangeRates() async throws -> Rates {
        return rates
    }
}

// Mock para NotificationService
class MockNotificationService: NotificationServiceProtocol {
    var didCheckPermission = false
    var lastDolar: String?
    
    func checkPermission(dolar: String) {
        didCheckPermission = true
        lastDolar = dolar
    }
}
