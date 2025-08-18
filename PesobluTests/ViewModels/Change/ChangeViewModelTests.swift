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
    var didFailCalled = false
    var didFinishCalled = false
    var mockRates: Rates? = Rates(UYU: Uyu(rawRate: "40.0"), BRL: Brl(rawRate: "5.0"), CLP: Clp(rawRate: "900.0"))

    override func setUp() {
        super.setUp()
        mockCurrencyService = MockCurrencyService()
        viewModel = ChangeViewModel(currencyService: mockCurrencyService, currencies: [], rates: Rates())
        viewModel.delegate = self
    }

    override func tearDown() {
        viewModel = nil
        mockCurrencyService = nil
        didFailCalled = false
        didFinishCalled = false
        super.tearDown()
    }

    // Prueba de éxito en fetchCurrencies
    func testFetchCurrenciesSuccess() async throws {
        mockCurrencyService.mockDolarMep = DolarMEP(currencyTitle: "title", currencyLabel: "label", moneda: "USD", casa: "Banco Central de Argentina", nombre: "Dolar Argentino MP", compra: 800.0, venta: 950.0, fechaActualizacion: "2025-05-26T00:00:00Z")
        mockCurrencyService.mockRates = Rates()

        await viewModel.getChangeOfCurrencies()

        XCTAssertFalse(viewModel.currencies.isEmpty, "Currencies should not be empty")
        XCTAssertNotNil(viewModel.rates, "Rates should be set")
        XCTAssertEqual(viewModel.currencies.count, 1 + CurrencyCode.allCases.count, "Should have \(1 + CurrencyCode.allCases.count) currencies after conversion")
        XCTAssertTrue(didFinishCalled)
    }

    // Prueba de fallo en fetchCurrencies
    func testFetchCurrenciesFailure() async {
        mockCurrencyService.shouldFail = true

        await viewModel.getChangeOfCurrencies()

        XCTAssertTrue(didFailCalled, "didFail should be called on failure")
    }

    func testGetChangeOfCurrenciesAppendsRatesAndNotifiesDelegate() async throws {
        let mep = DolarMEP(currencyTitle: nil,
                           currencyLabel: nil,
                           moneda: "USD",
                           casa: "",
                           nombre: "",
                           compra: 0,
                           venta: 100,
                           fechaActualizacion: "")
        mockCurrencyService.mockDolarMep = mep

        var rates = Rates()
        rates.EUR = Eur(currencyTitle: nil, currencyLabel: nil, rawRate: "2")
        mockCurrencyService.mockRates = rates

        await viewModel.getChangeOfCurrencies()

        XCTAssertEqual(viewModel.currencies.count, CurrencyCode.allCases.count + 1)
        XCTAssertEqual(viewModel.currencies.first?.currencyTitle, "USD MEP - Dólar Americano")
        XCTAssertEqual(viewModel.currencies.first?.currencyLabel, "Dólar Bolsa de Valores / MEP")
        let eurItem = viewModel.currencies.first { $0.currencyTitle == CurrencyCode.EUR.title }
        XCTAssertEqual(eurItem?.rate, "50.00")
        XCTAssertTrue(didFinishCalled)
    }

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
        didFinishCalled = true
    }

    func didFail(error: Error) {
        didFailCalled = true
    }
}
