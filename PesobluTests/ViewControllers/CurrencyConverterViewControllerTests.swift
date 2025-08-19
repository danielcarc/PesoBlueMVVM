import XCTest
import Combine
import UIKit
@testable import Pesoblu

final class CurrencyConverterViewControllerTests: XCTestCase {
    private var sut: CurrencyConverterViewController!
    private var mockViewModel: MockCurrencyConverterViewModel!
    private var mockCurrency: CurrencyItemMock!

    @MainActor
    override func setUp() {
        super.setUp()
        mockViewModel = MockCurrencyConverterViewModel()
        mockCurrency = CurrencyItemMock(currencyTitle: "Mock", currencyLabel: "Mock", rate: "0")
        sut = CurrencyConverterViewController(viewModel: mockViewModel, currency: mockCurrency)
    }

    @MainActor
    override func tearDown() {
        sut.stopTimer()
        sut = nil
        mockViewModel = nil
        mockCurrency = nil
        super.tearDown()
    }

    @MainActor
    func test_viewDidLoad_configuresController() {
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, "Convertir")
        XCTAssertTrue(mockViewModel.updateCurrencyCalled)
        XCTAssertTrue(mockViewModel.getConvertedValuesCalled)
        XCTAssertTrue(sut.view is CurrencyConverterView)
        let timer = sut.timerForTesting
        XCTAssertNotNil(timer)
        sut.stopTimer()
    }

    @MainActor
    func test_viewWillAppear_animatesView() {
        sut.loadViewIfNeeded()
        sut.view.alpha = 0.5
        sut.view.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.4))

        sut.viewWillAppear(false)

        XCTAssertEqual(sut.view.alpha, 1, accuracy: 0.001)
        XCTAssertEqual(sut.view.transform, .identity)
    }

    @MainActor
    func test_didTapBack_popsViewController() {
        let nav = MockNavigationController(rootViewController: sut)

        sut.didTapBack()

        XCTAssertTrue(nav.didPopViewController)
    }

    @MainActor
    func test_viewWillDisappear_invalidatesTimer() {
        sut.startTimer()
        sut.viewWillDisappear(false)
        let timer = sut.timerForTesting
        XCTAssertNil(timer)
    }
}

private final class MockCurrencyConverterViewModel: CurrencyConverterViewModelProtocol {
    var updateCurrencyCalled = false
    var getConvertedValuesCalled = false

    func getDolarBlue() async throws -> DolarBlue? { nil }
    func checkPermission(dolar: String) {}
    func getCurrencyArray() -> [String] { [] }
    func updateCurrency(selectedCurrency: CurrencyItem) {
        updateCurrencyCalled = true
    }
    func updateAmount(_ amount: Double?) {}
    func getConvertedValues() -> AnyPublisher<(String, String, String, String), Never> {
        getConvertedValuesCalled = true
        return Just(("", "", "", "")).eraseToAnyPublisher()
    }
}

private struct CurrencyItemMock: CurrencyItem {
    var currencyTitle: String?
    var currencyLabel: String?
    var rate: String?
}

private final class MockNavigationController: UINavigationController {
    var didPopViewController = false
    override func popViewController(animated: Bool) -> UIViewController? {
        didPopViewController = true
        return super.popViewController(animated: animated)
    }
}
