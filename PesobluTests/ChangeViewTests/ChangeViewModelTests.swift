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
    func testFetchCurrenciesSuccess() async {
        // Configurar el mock
        mockCurrencyService.mockDolarMep = DolarMEP(currencyTitle: "title", currencyLabel: "label", moneda: "USD", casa: "Banco Central de Argentina", nombre: "Dolar Argentino MP", compra: 800.0, venta: 950.0, fechaActualizacion: "2025-05-26T00:00:00Z")
        mockCurrencyService.mockRates = Rates()
        
        expectation = XCTestExpectation(description: "Fetch currencies completes")
        viewModel.delegate = self // Asegúrate de que el delegado esté configurado
        
        // Llamar al método asíncrono
        viewModel.getChangeOfCurrencies()
        
        // Esperar a que la tarea asíncrona termine
        await fulfillment(of: [expectation!], timeout: 1.0)
        
        // Verificar resultados
        XCTAssertFalse(viewModel.currencies.isEmpty, "Currencies should not be empty")
        XCTAssertNotNil(viewModel.rates, "Rates should be set")
        XCTAssertEqual(viewModel.currencies.count, 13, "Should have 13 currencies after conversion")
    }
    
    // Prueba de fallo en fetchCurrencies
    @MainActor
    func testFetchCurrenciesFailure() async {
        // Configurar el mock para fallar
        mockCurrencyService.shouldFail = true
        
        expectation = XCTestExpectation(description: "Fetch currencies fails")
        didFailCalled = false
        viewModel.delegate = self
        
        // Capturar el fallo
        viewModel.getChangeOfCurrencies()
        
        // Esperar a que la tarea asíncrona termine
        await fulfillment(of: [expectation!], timeout: 1.0)
        
        XCTAssertTrue(didFailCalled, "didFail should be called on failure")
    }
    
    
    @MainActor
    func testGetUyuValue() {
        _ = getUyuValue(currency: 950.0) // Usando el valor de DolarMEP
        XCTAssertEqual(mockRates?.UYU?.rawRate, "23.75", "Conversion should be 950 / 40")
        XCTAssertEqual(mockRates?.UYU?.currencyTitle, "UYU - Peso Uruguayo")
        XCTAssertEqual(mockRates?.UYU?.currencyLabel, "Uruguay")
    }
    
    func getUyuValue(currency: Double) -> Uyu {
        var uyu: Uyu
        if let uy = mockRates?.UYU {
            uyu = uy
        } else {
            uyu = Uyu(rawRate: "0.0")
        }
        let rateValue = Double(uyu.rawRate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        mockRates?.UYU?.rawRate = String(result)
        mockRates?.UYU?.currencyTitle = "UYU - Peso Uruguayo"
        mockRates?.UYU?.currencyLabel = "Uruguay"
        return (mockRates?.UYU!)!
    }
    
}

extension ChangeViewModelTests: ChangeViewModelDelegate {
    func didFinish() {
        print("Fetch completed successfully")
        expectation?.fulfill() // Cumplir la expectativa
    }
    
    func didFail(error: Error) {
        print("Fetch failed with error: \(error)")
        didFailCalled = true // Actualizar la variable
        expectation?.fulfill() // Cumplir la expectativa
    }
}
