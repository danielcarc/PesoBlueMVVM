//
//  QuickConversorView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 22/11/2024.
//

import UIKit

class QuickConversorView: UIView{
    
    private lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.text = "Conversor rápido"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor(named: "primaryText") ?? UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private lazy var usdContainerView : UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        //view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.heightAnchor.constraint(equalToConstant: 72).isActive = true
        return view
    }()
    
    private lazy var usdCodeLabel : UILabel = {
        var codeLabel = UILabel()
        codeLabel.text = "USD"
        codeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        codeLabel.textColor = UIColor(named: "primaryText") ?? UIColor.black
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    private lazy var usdDescriptionLabel : UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.text = "Dolar Americano"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(named: "secondaryText") ?? UIColor.gray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var usdValueLabel : UILabel = {
        var valueLabel = UILabel()
        valueLabel.text = "99.00"
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        valueLabel.textColor = UIColor(named: "primaryText") ?? UIColor.black
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        return valueLabel
    }()
    
    private lazy var usdLabelsStackView : UIStackView = {
        var labelStackView =  UIStackView(arrangedSubviews: [usdCodeLabel, usdDescriptionLabel])
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        return labelStackView
    }()
    
    private lazy var arsContainerView : UIView = {
        var view = UIView()
        view.backgroundColor = .white
        //view.layer.cornerRadius = 8
//        view.layer.borderWidth = 0.5
//        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.heightAnchor.constraint(equalToConstant: 72).isActive = true
        return view
    }()
    
    private lazy var arsCodeLabel : UILabel = {
        var codeLabel = UILabel()
        codeLabel.text = "ARS"
        codeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        codeLabel.textColor = UIColor(named: "primaryText") ?? UIColor.black
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    private lazy var arsDescriptionLabel : UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.text = "Peso Argentino"
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor(named: "secondaryText") ?? UIColor.gray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var arsValueLabel : UILabel = {
        var valueLabel = UILabel()
        valueLabel.text = "1000.00"
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        valueLabel.textColor = UIColor(named: "primaryText") ?? UIColor.black
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        return valueLabel
    }()
    
    private lazy var arsLabelsStackView : UIStackView = {
        var labelStackView =  UIStackView(arrangedSubviews: [arsCodeLabel, arsDescriptionLabel])
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        return labelStackView
    }()
    
    private lazy var stackView: UIStackView = {
        var stackview = UIStackView(arrangedSubviews: [usdContainerView, arsContainerView])
        
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
}

extension QuickConversorView{
    
    private func setupUI() {
        
        addSubViews()
        setupConstraints()
        
    }
    
    func addSubViews(){
        self.addSubview(titleLabel)
        self.addSubview(stackView)
        
        usdContainerView.addSubview(usdLabelsStackView)
        usdContainerView.addSubview(usdValueLabel)
        
        arsContainerView.addSubview(arsLabelsStackView)
        arsContainerView.addSubview(arsValueLabel)
        
    }
    
    func setupConstraints(){
        
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            
            // Stack View Constraints
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            usdContainerView.heightAnchor.constraint(equalToConstant: 50),
            arsContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            usdLabelsStackView.leadingAnchor.constraint(equalTo: usdContainerView.leadingAnchor, constant: 0),
            usdLabelsStackView.centerYAnchor.constraint(equalTo: usdContainerView.centerYAnchor),
            
            usdValueLabel.trailingAnchor.constraint(equalTo: usdContainerView.trailingAnchor, constant: -16),
            usdValueLabel.centerYAnchor.constraint(equalTo: usdContainerView.centerYAnchor),
            
            usdValueLabel.widthAnchor.constraint(equalToConstant: 80),
            
            arsLabelsStackView.leadingAnchor.constraint(equalTo: arsContainerView.leadingAnchor, constant: 0),
            arsLabelsStackView.centerYAnchor.constraint(equalTo: arsContainerView.centerYAnchor),
            
            arsValueLabel.trailingAnchor.constraint(equalTo: arsContainerView.trailingAnchor, constant: -16),
            arsValueLabel.centerYAnchor.constraint(equalTo: arsContainerView.centerYAnchor),
            
            arsValueLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
        
    }
}


