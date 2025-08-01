//
//  CurrencyRowView.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 31/07/2025.
//

import UIKit

final class ConversionRowView: UIView {
    
    private lazy var buyview: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Compra"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        var label = UILabel()
        label.text = "0.00"
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    

    init(title: String, value: String = "0.00") {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, value: value)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1) // Celeste claro 🇦🇷
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
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
