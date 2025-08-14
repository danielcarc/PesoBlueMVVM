import XCTest
import UIKit
@testable import Pesoblu

final class ChangeViewTests: XCTestCase {

    private func allLabels(in view: UIView) -> [UILabel] {
        var result: [UILabel] = []
        for subview in view.subviews {
            if let label = subview as? UILabel {
                result.append(label)
            } else {
                result.append(contentsOf: allLabels(in: subview))
            }
        }
        return result
    }

    func testSetUpdatesAllLabels() {
        let sut = ChangeView()
        sut.set(currencyTitle: "USD", currencyLabel: "Dólar", valueBuy: "100")

        let labels = allLabels(in: sut)
        XCTAssertTrue(labels.contains { $0.text == "USD" })
        XCTAssertTrue(labels.contains { $0.text == "Dólar" })

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_AR")
        let expected = formatter.string(from: 100 as NSNumber)
        XCTAssertTrue(labels.contains { $0.text == expected })
    }
}
