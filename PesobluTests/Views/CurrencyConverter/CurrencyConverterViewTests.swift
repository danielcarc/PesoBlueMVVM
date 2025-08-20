import XCTest
import UIKit
@testable import Pesoblu

final class CurrencyConverterViewTests: XCTestCase {

    // MARK: - Helpers
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

    private func allTextFields(in view: UIView) -> [UITextField] {
        var result: [UITextField] = []
        for subview in view.subviews {
            if let textField = subview as? UITextField {
                result.append(textField)
            } else {
                result.append(contentsOf: allTextFields(in: subview))
            }
        }
        return result
    }

    private func valueLabels(in view: UIView) -> [UILabel] {
        allLabels(in: view).filter { $0.font.fontDescriptor.symbolicTraits.contains(.traitBold) }
    }

    // MARK: - Tests
    func testInitialSetupConfiguresSubviewsAndStyles() {
        let view = CurrencyConverterView()

        XCTAssertEqual(view.backgroundColor, .white)

        let textFields = allTextFields(in: view)
        XCTAssertEqual(textFields.count, 1)
        XCTAssertEqual(textFields.first?.placeholder, "Ingrese la cantidad de dinero a convertir")

        let labels = allLabels(in: view)
        XCTAssertTrue(labels.contains { $0.text == "Compra" && $0.textColor == .systemBlue })
        XCTAssertTrue(labels.contains { $0.text == "En Dolares" && $0.textColor == .systemGreen })
        XCTAssertTrue(labels.contains { $0.text == "Compra" && $0.textColor == .systemIndigo })
        XCTAssertTrue(labels.contains { $0.text == "En Dolares" && $0.textColor == .systemOrange })

        let valueTexts = valueLabels(in: view)
        XCTAssertEqual(valueTexts.count, 4)
        XCTAssertTrue(valueTexts.allSatisfy { $0.text == "0.00" })
    }

    private struct CurrencyItemMock: CurrencyItem {
        var currencyTitle: String?
        var currencyLabel: String?
        var rate: String?
    }

    func testSetCurrencyUpdatesLabels() {
        let view = CurrencyConverterView()
        let code = CurrencyCode.UYU
        let item = CurrencyItemMock(currencyTitle: "Peso Uruguayo", currencyLabel: code.label, rate: "1")

        view.setCurrency(currency: item)

        let labels = allLabels(in: view)
        XCTAssertTrue(labels.contains { $0.text == "Peso Uruguayo" })
        XCTAssertTrue(labels.contains { $0.text == NSLocalizedString("currency.\(code.rawValue).toPeso", comment: "") })
        XCTAssertTrue(labels.contains { $0.text == NSLocalizedString("currency.\(code.rawValue).fromPeso", comment: "") })
        XCTAssertTrue(labels.contains { $0.text == NSLocalizedString("currency.\(code.rawValue).toDolar", comment: "") })
        XCTAssertTrue(labels.contains { $0.text == NSLocalizedString("currency.\(code.rawValue).fromDolar", comment: "") })
    }

    func testSetTitleLabelsUsesAllDictionaryEntries() {
        let view = CurrencyConverterView()

        for code in CurrencyCode.allCases {
            let item = CurrencyItemMock(currencyTitle: code.title, currencyLabel: code.label, rate: "1")
            view.setTitleLabels(currency: item)
            let labels = allLabels(in: view)
            XCTAssertTrue(labels.contains { $0.text == NSLocalizedString("currency.\(code.rawValue).toPeso", comment: "") })
            XCTAssertTrue(labels.contains { $0.text == NSLocalizedString("currency.\(code.rawValue).fromPeso", comment: "") })
            XCTAssertTrue(labels.contains { $0.text == NSLocalizedString("currency.\(code.rawValue).toDolar", comment: "") })
            XCTAssertTrue(labels.contains { $0.text == NSLocalizedString("currency.\(code.rawValue).fromDolar", comment: "") })
        }
    }

    func testResetControlsRestoresZeroValues() {
        let view = CurrencyConverterView()
        view.updateValues(fromPeso: "1", toPeso: "2", fromDolar: "3", toDolar: "4")

        view.resetControls()

        let values = valueLabels(in: view)
        XCTAssertTrue(values.allSatisfy { $0.text == "0.00" })
    }

    func testOnAmountChangedCalledWhenEditingChanges() {
        let view = CurrencyConverterView()
        var captured: Double?
        view.onAmountChanged = { captured = $0 }

        let textField = allTextFields(in: view).first
        textField?.text = "42.5"
        textField?.sendActions(for: .editingChanged)

        XCTAssertEqual(captured, 42.5)
    }
}

