//
//  CurrencyRowView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 31/07/2025.
//

import UIKit

final class ConversionRowView: UIView  {
    
    private lazy var buyview: UIView = {
        var view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("buy_label", comment: "")
        label.font = .systemFont(ofSize: 17)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        var label = UILabel()
        label.text = "0.00"
        label.font = .systemFont(ofSize: 22)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    

    init(title: String, value: String = "0.00") {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, value: value)
    }

    /// This view is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    private func setupUI() {
        backgroundColor = .systemBackground // Celeste claro 🇦🇷
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(buyview)
        buyview.addSubview(titleLabel)
        buyview.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            
            buyview.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            buyview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buyview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buyview.heightAnchor.constraint(equalToConstant: 91),
            
            titleLabel.leadingAnchor.constraint(equalTo: buyview.leadingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: buyview.centerYAnchor),
            
            valueLabel.centerYAnchor.constraint(equalTo: buyview.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: buyview.trailingAnchor, constant: -8),
        ])
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }

    func updateValue(_ newValue: String) {
        valueLabel.text = newValue
    }
}
