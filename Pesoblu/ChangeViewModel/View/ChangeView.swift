//
//  CurrencyView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 02/10/23.
//

import UIKit

//hacer un una vista como la que me muestra Galileo AI
// ex : Ars - Peso Argentino               1000
//      Argentina

class ChangeView: UIView {

    private lazy var viewDolar: UIView = {
        var view = UIView()
        view.backgroundColor = .white //UIColor(hex: "F0F8FF")
        //view.backgroundColor = UIColor(red: 213/255.0, green: 229/255.0, blue: 252/255.0, alpha: 1)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackHorizontal: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var viewCurrencyTitle: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        //view.layer.cornerRadius = 10
        //view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewCurrencyLabel: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        //view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewValueBuyLabel: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        //view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currencyTitleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black//UIColor(red: 64/255.0, green: 154/255.0, blue: 255/255.0, alpha: 1)
        label.text = "Dolar Oficial"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencySubtitleLabel: UILabel = {
        var label = UILabel()
        
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14)
        label.text = "Argentina"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencyValueLabel: UILabel = {
        var label = UILabel()
        
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.text = "174"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(currencyTitle: String, currencyLabel: String, valueBuy: Double){
        currencyTitleLabel.text = currencyTitle
        currencyValueLabel.text = String(format: "%.2f", valueBuy)// este es el qie muestra el valor
        currencySubtitleLabel.text = currencyLabel
    }
    
}

private extension ChangeView {
    func setup(){
        
        addsubviews()
        setupConstraints()
    }
    
    private func addsubviews(){
        self.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewDolar)
        
        viewDolar.addSubview(stackHorizontal)
        stackHorizontal.addArrangedSubview(titleStackView)
        stackHorizontal.addArrangedSubview(viewValueBuyLabel)
        
        titleStackView.addArrangedSubview(viewCurrencyTitle)
        titleStackView.addArrangedSubview(viewCurrencyLabel)
        
        viewCurrencyTitle.addSubview(currencyTitleLabel)
        viewCurrencyLabel.addSubview(currencySubtitleLabel)
        viewValueBuyLabel.addSubview(currencyValueLabel)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            viewDolar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            viewDolar.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            viewDolar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            viewDolar.heightAnchor.constraint(equalToConstant: 80),
            
            //stackhorizontal constraints
            stackHorizontal.leadingAnchor.constraint(equalTo: viewDolar.leadingAnchor, constant: 10),
            stackHorizontal.topAnchor.constraint(equalTo: viewDolar.topAnchor, constant: 10),
            stackHorizontal.trailingAnchor.constraint(equalTo: viewDolar.trailingAnchor, constant: -10), // Corregido
            stackHorizontal.bottomAnchor.constraint(equalTo: viewDolar.bottomAnchor, constant: -10),
            
            currencyTitleLabel.leadingAnchor.constraint(equalTo: viewCurrencyTitle.leadingAnchor),
            currencyTitleLabel.trailingAnchor.constraint(equalTo: viewCurrencyTitle.trailingAnchor),
            currencyTitleLabel.topAnchor.constraint(equalTo: viewCurrencyTitle.topAnchor),
            currencyTitleLabel.bottomAnchor.constraint(equalTo: viewCurrencyTitle.bottomAnchor),
            
            currencySubtitleLabel.leadingAnchor.constraint(equalTo: viewCurrencyLabel.leadingAnchor, constant: 0), // Indentar el subtítulo
            currencySubtitleLabel.trailingAnchor.constraint(equalTo: viewCurrencyLabel.trailingAnchor),
            currencySubtitleLabel.topAnchor.constraint(equalTo: viewCurrencyLabel.topAnchor),
            currencySubtitleLabel.bottomAnchor.constraint(equalTo: viewCurrencyLabel.bottomAnchor),
            
            currencyValueLabel.trailingAnchor.constraint(equalTo: viewValueBuyLabel.trailingAnchor),
            currencyValueLabel.topAnchor.constraint(equalTo: viewValueBuyLabel.topAnchor),
            currencyValueLabel.bottomAnchor.constraint(equalTo: viewValueBuyLabel.bottomAnchor),
            currencyValueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            
        ])
        
    }
}
