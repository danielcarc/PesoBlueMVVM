//
//  ChangeCell.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 25/07/2025.
//
import UIKit

class ChangeCell: UICollectionViewCell {

    static let identifier = "ChangeCell"

    private lazy var changeView = ChangeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /// This view is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        changeView.set(currencyTitle: "", currencyLabel: "", valueBuy: "")
    }

    func set(currencyTitle: String, currencyLabel: String, valueBuy: String) {
        changeView.set(currencyTitle: currencyTitle,
                       currencyLabel: currencyLabel,
                       valueBuy: valueBuy)
    }
    
    private func setup() {
        contentView.backgroundColor = .clear
        changeView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(changeView)
        
        NSLayoutConstraint.activate([
            changeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            changeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            changeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            changeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
}
