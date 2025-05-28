//
//  CurrencyConverterViewModelTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 25/03/2025.
//

import XCTest
import Combine
@testable import Pesoblu

class CurrencyConverterViewModelTests: XCTestCase {
    var viewModel: MockCurrencyConverterViewModel!
    let mockCurrencyService = MockCurrencyService()
    let mockNotificationService = MockNotificationService()
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockCurrencyService.mockRates = Rates(UYU: Uyu(rawRate: "40.0"), BRL: Brl(rawRate: "5.0"), CLP: Clp(rawRate: "900.0"))
        //mockCurrencyService.dolarValue = 150.0
        viewModel = MockCurrencyConverterViewModel(currencyService: mockCurrencyService, notificationService: mockNotificationService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testConvertDolarSuccess() async throws {
        mockCurrencyService.mockDolarMep = DolarMEP(moneda: "Moneda", casa: "casa", nombre: "moneda", compra: 900.0, venta: 950.0, fechaActualizacion: "fecha")
        let quantity = 1800.0
        let result = try await viewModel.convertDolar(quantity: quantity)
        XCTAssertEqual(result, "2.00")
    }
    
    func testConvertDolarThrowsInvalidRate() async {
        mockCurrencyService.mockDolarMep = DolarMEP(moneda: "Moneda", casa: "casa", nombre: "moneda", compra: 900.0, venta: 950.0, fechaActualizacion: "fecha")
        do {
            _ = try await viewModel.convertDolar(quantity: 300.0)
            XCTFail("Debería haber lanzado un error")
        } catch ConversionError.invalidDollarRate {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Lanzó un error inesperado: \(error)")
        }
    }
    
    func testGetTextForPicker() {
        XCTAssertEqual(viewModel.getTextForPicker(row: 0), "Real Brasil")
        XCTAssertEqual(viewModel.getTextForPicker(row: 1), "Peso Chile")
        XCTAssertEqual(viewModel.getTextForPicker(row: 2), "Peso Uruguay")
        XCTAssertEqual(viewModel.getTextForPicker(row: 999), "error")
    }
    
    func testConvertedValuesPublishesCorrectly() async {
        // Given
        mockCurrencyService.mockDolarMep = DolarMEP(moneda: "Moneda", casa: "casa", nombre: "moneda", compra: 900.0, venta: 950.0, fechaActualizacion: "fecha")
        viewModel.updateAmount(300.0)
        viewModel.updateCurrency(currency: "BRL")
        
        let expectation = XCTestExpectation(description: "Converted values received")
        
        // When
        viewModel.getConvertedValues()
            .sink { values in
                // Then
                XCTAssertEqual(values.0, "10.00")
                XCTAssertEqual(values.1, "9000.00")
                XCTAssertEqual(values.2, "2.00")
                XCTAssertEqual(values.3, "60.00")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
