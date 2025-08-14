import XCTest
@testable import Pesoblu

final class ChangeViewModelTests: XCTestCase {

    private final class MockCurrencyService: CurrencyServiceProtocol {
        var mep: DolarMEP?
        var rates: Rates

        init(mep: DolarMEP?, rates: Rates) {
            self.mep = mep
            self.rates = rates
        }

        func getDolarBlue() async throws -> DolarBlue? { return nil }
        func getValueForCountry(countryCode: String) async throws -> String { "" }
        func getDolarOficial() async throws -> DolarOficial? { return nil }
        func getDolarMep() async throws -> DolarMEP? { mep }
        func getChangeOfCurrencies() async throws -> Rates { rates }
    }

    private final class DelegateSpy: ChangeViewModelDelegate {
        let expectation: XCTestExpectation
        init(expectation: XCTestExpectation) { self.expectation = expectation }
        func didFinish() { expectation.fulfill() }
        func didFail(error: Error) { XCTFail("Unexpected error: \(error)") }
    }

    func testGetChangeOfCurrenciesAppendsRatesAndNotifiesDelegate() {
        let mep = DolarMEP(currencyTitle: nil,
                            currencyLabel: nil,
                            moneda: "USD",
                            casa: "",
                            nombre: "",
                            compra: 0,
                            venta: 100,
                            fechaActualizacion: "")

        let rates = Rates(EUR: Eur(currencyTitle: nil, currencyLabel: nil, rawRate: "2"))
        let service = MockCurrencyService(mep: mep, rates: rates)
        let expectation = expectation(description: "didFinish")
        let delegate = DelegateSpy(expectation: expectation)
        let sut = ChangeViewModel(delegate: delegate, currencyService: service, currencies: [], rates: Rates())

        sut.getChangeOfCurrencies()

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(sut.currencies.count, CurrencyCode.allCases.count + 1)
        XCTAssertEqual(sut.currencies.first?.currencyTitle, "USD MEP - Dólar Americano")
        XCTAssertEqual(sut.currencies.first?.currencyLabel, "Dólar Bolsa de Valores / MEP")
        let eurItem = sut.currencies.first { $0.currencyTitle == CurrencyCode.EUR.title }
        XCTAssertEqual(eurItem?.rate, "50.00")
    }
}
