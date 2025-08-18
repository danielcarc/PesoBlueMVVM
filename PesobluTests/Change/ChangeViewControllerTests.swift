import XCTest
import UIKit
@testable import Pesoblu

final class ChangeViewControllerTests: XCTestCase {

    private final class MockViewModel: ChangeViewModelProtocol {
        var delegate: ChangeViewModelDelegate?
        var currencies: [CurrencyItem] = []
        private(set) var getChangeCalled = 0
        func getChangeOfCurrencies() async { getChangeCalled += 1 }
    }

    func testViewDidLoadSetsUpCollectionViewAndStartsFetching() async {
        let viewModel = MockViewModel()
        let collectionView = ChangeCollectionView(viewModel: viewModel)
        let sut = ChangeViewController(viewModel: viewModel, changeCView: collectionView)

        sut.loadViewIfNeeded()
        await Task.yield()

        XCTAssertTrue(collectionView.delegate === sut)
        XCTAssertEqual(viewModel.getChangeCalled, 1)
        XCTAssertEqual(sut.title, "Cotización")
    }
}
