//
//  ChangeViewModelTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 26/05/2025.
//

import XCTest

@testable import Pesoblu

final class ChangeViewModelTests: XCTestCase {
    
    var viewModel: ChangeViewModel!
    var mockCurrencyService: MockCurrencyService!
    var expectation: XCTestExpectation? // Declarar expectation como propiedad
    var didFailCalled: Bool = false
    var mockRates: Rates? = Rates(UYU: Uyu(rawRate: "40.0"), BRL: Brl(rawRate: "5.0"), CLP: Clp(rawRate: "900.0"))
    
    @MainActor override func setUp(){
        super.setUp()
        mockCurrencyService = MockCurrencyService()
        viewModel = ChangeViewModel(currencyService: mockCurrencyService, currencies: [], rates: Rates())
        viewModel.delegate = self
    }
    
    override func tearDown() {
        viewModel = nil
        mockCurrencyService = nil
        expectation = nil
        didFailCalled = false
        super.tearDown()
    }
    
    // Prueba de éxito en fetchCurrencies
    @MainActor
    func testFetchCurrenciesSuccess() {
        // Configurar el mock
        mockCurrencyService.mockDolarMep = DolarMEP(currencyTitle: "title", currencyLabel: "label", moneda: "USD", casa: "Banco Central de Argentina", nombre: "Dolar Argentino MP", compra: 800.0, venta: 950.0, fechaActualizacion: "2025-05-26T00:00:00Z")
        mockCurrencyService.mockRates = Rates()
        
        expectation = XCTestExpectation(description: "Fetch currencies completes")
        viewModel.delegate = self // Asegúrate de que el delegado esté configurado
        
        // Llamar al método asíncrono
        viewModel.getChangeOfCurrencies()
        
        // Esperar a que la tarea asíncrona termine
        wait(for: [expectation!], timeout: 1.0)

        // Verificar resultados
        XCTAssertFalse(viewModel.currencies.isEmpty, "Currencies should not be empty")
        XCTAssertNotNil(viewModel.rates, "Rates should be set")
        XCTAssertEqual(viewModel.currencies.count, 1 + CurrencyCode.allCases.count, "Should have \(1 + CurrencyCode.allCases.count) currencies after conversion")
    }
    
    // Prueba de fallo en fetchCurrencies
    @MainActor
    func testFetchCurrenciesFailure() {
        // Configurar el mock para fallar
        mockCurrencyService.shouldFail = true
        
        expectation = XCTestExpectation(description: "Fetch currencies fails")
        didFailCalled = false
        viewModel.delegate = self
        
        // Capturar el fallo
        viewModel.getChangeOfCurrencies()
        
        // Esperar a que la tarea asíncrona termine
        wait(for: [expectation!], timeout: 1.0)

        XCTAssertTrue(didFailCalled, "didFail should be called on failure")
    }
    
    @MainActor
    func testGetCurrencyValue() {
        viewModel.rates = mockRates ?? Rates()
        let item = viewModel.getCurrencyValue(for: .UYU, currency: 950.0)
        XCTAssertEqual(item.rate, "23.75", "Conversion should be 950 / 40")
        XCTAssertEqual(item.currencyTitle, "UYU - Peso Uruguayo")
        XCTAssertEqual(item.currencyLabel, "Uruguay")
    }

}

extension ChangeViewModelTests: ChangeViewModelDelegate {
    func didFinish() {
        expectation?.fulfill() // Cumplir la expectativa
    }

    func didFail(error: Error) {
        didFailCalled = true // Actualizar la variable
        expectation?.fulfill() // Cumplir la expectativa
    }
}
