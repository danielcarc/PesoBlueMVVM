//
//  ChangeCollectionViewTests.swift
//  PesobluTests
//
//  Created by OpenAI's ChatGPT on 2025.
//

import XCTest
import UIKit
@testable import Pesoblu

final class ChangeCollectionViewTests: XCTestCase {

    private final class MockViewModel: ChangeViewModelProtocol {
        var delegate: ChangeViewModelDelegate?
        var currencies: [CurrencyItem]

        init(currencies: [CurrencyItem] = []) {
            self.currencies = currencies
        }

        func getChangeOfCurrencies() async {
            delegate?.didFinish()
        }

        func sendDidFinish() {
            delegate?.didFinish()
        }
    }

    private func makeCurrencies(count: Int) -> [CurrencyItem] {
        return (0..<count).map { _ in
            CurrencyConversion(currencyTitle: nil, currencyLabel: nil, rate: "0")
        }
    }

    @MainActor func testOnHeightChangeMatchesContentHeightForVariousCounts() {
        let counts = [0, 1, 3]
        for count in counts {
            let viewModel = MockViewModel(currencies: makeCurrencies(count: count))
            let sut = ChangeCollectionView(viewModel: viewModel)
            let expectation = expectation(description: "height for count \(count)")

            sut.onHeightChange = { height in
                guard let collectionView = sut.subviews.compactMap({ $0 as? UICollectionView }).first else {
                    XCTFail("Missing collection view")
                    return
                }
                let expectedHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
                XCTAssertEqual(height, expectedHeight)
                expectation.fulfill()
            }

            viewModel.sendDidFinish()
            wait(for: [expectation], timeout: 1.0)
        }
    }

    @MainActor func testDidSelectCurrencyNotifiesDelegate() {
        let item = CurrencyConversion(currencyTitle: "USD", currencyLabel: "Dollar", rate: "1")
        let viewModel = MockViewModel(currencies: [item])
        let sut = ChangeCollectionView(viewModel: viewModel)

        final class DelegateSpy: ChangeCollectionViewDelegate {
            var selected: CurrencyItem?
            let expectation: XCTestExpectation
            init(expectation: XCTestExpectation) { self.expectation = expectation }
            func didSelectCurrency(for currencyItem: CurrencyItem) {
                selected = currencyItem
                expectation.fulfill()
            }
        }

        let expectation = expectation(description: "delegate called")
        let spy = DelegateSpy(expectation: expectation)
        sut.delegate = spy

        viewModel.sendDidFinish()

        guard let collectionView = sut.subviews.compactMap({ $0 as? UICollectionView }).first else {
            XCTFail("Missing collection view")
            return
        }

        sut.collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(spy.selected)
        XCTAssertEqual(spy.selected?.currencyTitle ?? "", "USD")
    }
}
