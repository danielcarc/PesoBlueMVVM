//
//  CurrencyView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 02/10/23.
//

import UIKit

class ChangeView: UIView {

    private lazy var viewDolar: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 213/255.0, green: 229/255.0, blue: 252/255.0, alpha: 1)
        view.layer.cornerRadius = 10
        //view.layer.borderWidth = 1
        //view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewLabelDolarOficial: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewLabelDolarOficialCompra: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var viewLabelDolarOficialVenta: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currencyTipeLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(red: 64/255.0, green: 154/255.0, blue: 255/255.0, alpha: 1)
        label.text = "Dolar Oficial"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencyBuyLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemGray2
        label.text = "Compra"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencyBuyValueLabel: UILabel = {
        var label = UILabel()
        
        label.textColor = .black
        label.font = .systemFont(ofSize: 22)
        label.text = "174"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var currencySellLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemGray2
        label.text = "Venta"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencySellValueLabel: UILabel = {
        var label = UILabel()
        
        label.textColor = .black
        label.font = .systemFont(ofSize: 22)
        label.text = "193"
        label.textAlignment = .center
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
    
    
    
    func set(nameLabel: String, valueSell: Double, valueBuy: Double){
        currencyTipeLabel.text = nameLabel
        currencyBuyValueLabel.text = String(format: "%.2f", valueBuy)
        currencySellValueLabel.text = String(format: "%.2f", valueSell)
        
        
    }
    
}

private extension ChangeView {
    func setup(){
        
        addsubviews()
        setupConstraints()
    }
    
    private func addsubviews(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewDolar)
        
        viewDolar.addSubview(viewLabelDolarOficial)
        viewDolar.addSubview(viewLabelDolarOficialCompra)
        viewDolar.addSubview(viewLabelDolarOficialVenta)
        
        viewLabelDolarOficial.addSubview(currencyTipeLabel)
        
        viewLabelDolarOficialCompra.addSubview(currencyBuyLabel)
        viewLabelDolarOficialCompra.addSubview(currencyBuyValueLabel)
        
        viewLabelDolarOficialVenta.addSubview(currencySellLabel)
        viewLabelDolarOficialVenta.addSubview(currencySellValueLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            viewDolar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            viewDolar.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            viewDolar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            viewDolar.heightAnchor.constraint(equalToConstant: 155),
            
            
            viewLabelDolarOficial.leadingAnchor.constraint(equalTo: viewDolar.leadingAnchor, constant: 8),
            viewLabelDolarOficial.topAnchor.constraint(equalTo: viewDolar.topAnchor, constant: 8),
            viewLabelDolarOficial.trailingAnchor.constraint(equalTo: viewDolar.trailingAnchor, constant: -8),
            viewLabelDolarOficial.heightAnchor.constraint(equalToConstant: 40),
            
            viewLabelDolarOficialCompra.leadingAnchor.constraint(equalTo: viewDolar.leadingAnchor, constant: 8),
            viewLabelDolarOficialCompra.topAnchor.constraint(equalTo: viewLabelDolarOficial.bottomAnchor, constant: 8),
            viewLabelDolarOficialCompra.widthAnchor.constraint(equalTo: viewDolar.widthAnchor, multiplier: 0.5, constant: -12),
            viewLabelDolarOficialCompra.bottomAnchor.constraint(equalTo: viewDolar.bottomAnchor, constant: -8),
            
            viewLabelDolarOficialVenta.widthAnchor.constraint(equalTo: viewDolar.widthAnchor, multiplier: 0.5, constant: -12),
            viewLabelDolarOficialVenta.trailingAnchor.constraint(equalTo: viewDolar.trailingAnchor, constant: -8),
            viewLabelDolarOficialVenta.topAnchor.constraint(equalTo: viewLabelDolarOficial.bottomAnchor, constant: 8),
            viewLabelDolarOficialVenta.bottomAnchor.constraint(equalTo: viewDolar.bottomAnchor, constant: -8),
            
            currencyTipeLabel.centerXAnchor.constraint(equalTo: viewLabelDolarOficial.centerXAnchor),
            currencyTipeLabel.centerYAnchor.constraint(equalTo: viewLabelDolarOficial.centerYAnchor),
            
            currencyBuyLabel.centerXAnchor.constraint(equalTo: viewLabelDolarOficialCompra.centerXAnchor),
            currencyBuyLabel.topAnchor.constraint(equalTo: viewLabelDolarOficialCompra.topAnchor, constant: 8),
            
            currencyBuyValueLabel.centerXAnchor.constraint(equalTo: viewLabelDolarOficialCompra.centerXAnchor),
            currencyBuyValueLabel.bottomAnchor.constraint(equalTo: viewLabelDolarOficialCompra.bottomAnchor, constant: -8),
            
            currencySellLabel.centerXAnchor.constraint(equalTo: viewLabelDolarOficialVenta.centerXAnchor),
            currencySellLabel.topAnchor.constraint(equalTo: viewLabelDolarOficialVenta.topAnchor, constant: 8),
            
            currencySellValueLabel.centerXAnchor.constraint(equalTo: viewLabelDolarOficialVenta.centerXAnchor),
            currencySellValueLabel.bottomAnchor.constraint(equalTo: viewLabelDolarOficialVenta.bottomAnchor, constant: -8)
        
        ])
        
    }
}
