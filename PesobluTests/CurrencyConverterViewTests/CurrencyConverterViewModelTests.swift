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
    var sut: MockCurrencyConverterViewModel!
    let mockCurrencyService = MockCurrencyService()
    let mockNotificationService = MockNotificationService()
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockCurrencyService.mockRates = Rates(UYU: Uyu(rawRate: "40.0"), BRL: Brl(rawRate: "5.0"), CLP: Clp(rawRate: "900.0"))
        //mockCurrencyService.dolarValue = 150.0
        sut = MockCurrencyConverterViewModel(currencyService: mockCurrencyService, notificationService: mockNotificationService)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testConvertDolarSuccess() async throws {
        mockCurrencyService.mockDolarMep = DolarMEP(moneda: "Moneda", casa: "casa", nombre: "moneda", compra: 900.0, venta: 900.0, fechaActualizacion: "fecha")
        let quantity = 1800.0
        let result = try await sut.convertDolar(quantity: quantity)
        XCTAssertEqual(result, "2.00")
    }
    
    func testConvertDolarThrowsInvalidRate() async {
        mockCurrencyService.mockDolarMep = DolarMEP(moneda: "Moneda", casa: "casa", nombre: "moneda", compra: 900.0, venta: 0.0, fechaActualizacion: "fecha")
        do {
            _ = try await sut.convertDolar(quantity: 300.0)
            XCTFail("Debería haber lanzado un error")
        } catch ConversionError.invalidDollarRate {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Lanzó un error inesperado: \(error)")
        }
    }
    
    func testGetTextForPicker() {
        XCTAssertEqual(sut.getTextForPicker(row: 0), "Real Brasil")
        XCTAssertEqual(sut.getTextForPicker(row: 1), "Peso Chile")
        XCTAssertEqual(sut.getTextForPicker(row: 2), "Peso Uruguay")
        XCTAssertEqual(sut.getTextForPicker(row: 999), "error")
    }
    
    func testConvertedValuesPublishesCorrectly() {
        // Given
        mockCurrencyService.mockDolarMep = DolarMEP(moneda: "Moneda", casa: "casa", nombre: "moneda", compra: 900.0, venta: 900.0, fechaActualizacion: "fecha")
        sut.updateAmount(450.0)
        sut.updateCurrency(currency: "BRL")
        
        let expectation = XCTestExpectation(description: "Converted values received")
        
        // When
        sut.getConvertedValues()
            .sink { values in
                // Then
                XCTAssertEqual(values.0, "2.50")
                XCTAssertEqual(values.1, "81000.00")
                XCTAssertEqual(values.2, "0.50")
                XCTAssertEqual(values.3, "90.00")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
