//
//  ChangeCellTests.swift
//  PesobluTests
//
//  Created by OpenAI's ChatGPT on 2025.
//

import XCTest
import UIKit
@testable import Pesoblu

final class ChangeCellTests: XCTestCase {

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

    func testPrepareForReuseClearsContent() {
        let cell = ChangeCell()
        cell.set(currencyTitle: "USD", currencyLabel: "Dollar", valueBuy: "100")

        let labelsBefore = allLabels(in: cell.contentView)
        XCTAssertFalse(labelsBefore.allSatisfy { ($0.text ?? "").isEmpty })

        cell.prepareForReuse()

        let labelsAfter = allLabels(in: cell.contentView)
        XCTAssertTrue(labelsAfter.allSatisfy { ($0.text ?? "").isEmpty })
    }

    func testDequeuesChangeCellWithIdentifier() {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChangeCell.self, forCellWithReuseIdentifier: ChangeCell.identifier)

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChangeCell.identifier,
            for: IndexPath(item: 0, section: 0)
        )

        XCTAssertTrue(cell is ChangeCell)
    }
}

