//
//  MockCurrencyService.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 26/05/2025.
//

import Foundation
@testable import Pesoblu

class MockCurrencyService: CurrencyServiceProtocol {
    var shouldFail = false
    var mockDolarMep: DolarMEP?
    var mockRates: Rates? = Rates(UYU: Uyu(rawRate: "40.0"), BRL: Brl(rawRate: "5.0"), CLP: Clp(rawRate: "900.0"))//modifique esto...
    
    
    func getDolarBlue() async throws -> DolarBlue? {
        if shouldFail { throw APIError.invalidResponse }
        return DolarBlue(moneda: "Moneda", casa: "casa", nombre: "moneda", compra: 850.0, venta: 900.0, fechaActualizacion: "fecha") // Valor simulado
    }
    
    func getDolarOficial() async throws -> DolarOficial? {
        if shouldFail { throw APIError.invalidResponse }
        return DolarOficial(moneda: "Moneda", casa: "casa", nombre: "moneda", compra: 750.0, venta: 800.0, fechaActualizacion: "fecha") // Valor simulado
    }
    
    func getDolarMep() async throws -> DolarMEP? {
        if shouldFail { throw APIError.invalidResponse }
        return mockDolarMep ?? DolarMEP(moneda: "Moneda", casa: "casa", nombre: "moneda", compra: 900.0, venta: 900.0, fechaActualizacion: "fecha") // Valor simulado
    }
    
    func getValueForCountry(countryCode: String) async throws -> String {
        if shouldFail { throw APIError.invalidResponse }
        return "100.00" // Valor simulado
    }
    
    func getChangeOfCurrencies() async throws -> Rates {
        if shouldFail { throw APIError.invalidResponse }
        return mockRates! // Valor simulado
    }
}
