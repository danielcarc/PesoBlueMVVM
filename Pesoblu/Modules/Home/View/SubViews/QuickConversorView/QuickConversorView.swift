//
//  QuickConversorView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 22/11/2024.
//

import UIKit

final class QuickConversorView: UIView{

    private lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("quick_converter_title", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: LayoutConstants.converterTitleFontSize)
        label.textColor = UIColor(named: "primaryText") ?? UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var usdContainerView : UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = LayoutConstants.containerCornerRadius
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var usdCodeLabel : UILabel = {
        var codeLabel = UILabel()
        codeLabel.text = NSLocalizedString("usd_code", comment: "")
        codeLabel.font = UIFont.systemFont(ofSize: LayoutConstants.currencyCodeFontSize, weight: .medium)
        codeLabel.textColor = UIColor(named: "primaryText") ?? UIColor.black
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    private lazy var usdDescriptionLabel : UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.text = NSLocalizedString("usd_description", comment: "")
        descriptionLabel.font = UIFont.systemFont(ofSize: LayoutConstants.currencyDescriptionFontSize, weight: .regular)
        descriptionLabel.textColor = UIColor(named: "secondaryText") ?? UIColor.gray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var usdValueLabel : UILabel = {
        var valueLabel = UILabel()
        valueLabel.text = NSLocalizedString("default_usd_value", comment: "")
        valueLabel.font = UIFont.systemFont(ofSize: LayoutConstants.currencyValueFontSize, weight: .regular)
        valueLabel.textColor = UIColor(named: "primaryText") ?? UIColor.black
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        return valueLabel
    }()
    
    private lazy var usdLabelsStackView : UIStackView = {
        var labelStackView =  UIStackView(arrangedSubviews: [usdCodeLabel, usdDescriptionLabel])

        labelStackView.axis = .vertical
        labelStackView.spacing = LayoutConstants.tinySpacing
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        return labelStackView
    }()
    
    private lazy var arsContainerView : UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = LayoutConstants.containerCornerRadius
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var arsCodeLabel : UILabel = {
        var codeLabel = UILabel()
        codeLabel.text = NSLocalizedString("ars_code", comment: "")
        codeLabel.font = UIFont.systemFont(ofSize: LayoutConstants.currencyCodeFontSize, weight: .medium)
        codeLabel.textColor = UIColor(named: "primaryText") ?? UIColor.black
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    private lazy var arsDescriptionLabel : UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.text = NSLocalizedString("ars_description", comment: "")
        descriptionLabel.font = UIFont.systemFont(ofSize: LayoutConstants.currencyDescriptionFontSize, weight: .regular)
        descriptionLabel.textColor = UIColor(named: "secondaryText") ?? UIColor.gray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var arsValueLabel : UILabel = {
        var valueLabel = UILabel()
        valueLabel.text = NSLocalizedString("default_ars_value", comment: "")
        valueLabel.font = UIFont.systemFont(ofSize: LayoutConstants.currencyValueFontSize, weight: .regular)
        valueLabel.textColor = UIColor(named: "primaryText") ?? UIColor.black
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        return valueLabel
    }()
    
    private lazy var arsLabelsStackView : UIStackView = {
        var labelStackView =  UIStackView(arrangedSubviews: [arsCodeLabel, arsDescriptionLabel])

        labelStackView.axis = .vertical
        labelStackView.spacing = LayoutConstants.tinySpacing
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        return labelStackView
    }()
    
    private lazy var stackView: UIStackView = {
        var stackview = UIStackView(arrangedSubviews: [usdContainerView, arsContainerView])

        stackview.axis = .vertical
        stackview.spacing = LayoutConstants.smallPadding
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
    
    func setDolar(dolar: Double){
        let dolarBlue = String(format: "%.2f", dolar)
        usdValueLabel.text = String(format: NSLocalizedString("currency_format", comment: ""), dolarBlue)
    }
    
    func setValue(value: String){
        arsValueLabel.text = String(format: NSLocalizedString("currency_format", comment: ""), value)
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
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LayoutConstants.edgePadding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -LayoutConstants.edgePadding),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutConstants.smallPadding),
            
            // Stack View Constraints
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: LayoutConstants.edgePadding),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -LayoutConstants.edgePadding),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: LayoutConstants.smallPadding),
            
            usdContainerView.heightAnchor.constraint(equalToConstant: LayoutConstants.converterContainerHeight),
            arsContainerView.heightAnchor.constraint(equalToConstant: LayoutConstants.converterContainerHeight),
            
            usdLabelsStackView.leadingAnchor.constraint(equalTo: usdContainerView.leadingAnchor, constant: LayoutConstants.smallPadding),
            usdLabelsStackView.centerYAnchor.constraint(equalTo: usdContainerView.centerYAnchor),
            
            usdValueLabel.trailingAnchor.constraint(equalTo: usdContainerView.trailingAnchor, constant: -LayoutConstants.largeSpacing),
            usdValueLabel.centerYAnchor.constraint(equalTo: usdContainerView.centerYAnchor),
            
            usdValueLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.valueLabelWidth),
            
            arsLabelsStackView.leadingAnchor.constraint(equalTo: arsContainerView.leadingAnchor, constant: LayoutConstants.smallPadding),
            arsLabelsStackView.centerYAnchor.constraint(equalTo: arsContainerView.centerYAnchor),
            
            arsValueLabel.trailingAnchor.constraint(equalTo: arsContainerView.trailingAnchor, constant: -LayoutConstants.largeSpacing),
            arsValueLabel.centerYAnchor.constraint(equalTo: arsContainerView.centerYAnchor),
            
            arsValueLabel.widthAnchor.constraint(equalToConstant: LayoutConstants.valueLabelWidth)
        ])
        
    }
}

//MARK: - QuickConversorView Testing

extension QuickConversorView{
    var usdLabelTesting: UILabel {
        return usdValueLabel
    }
    var arsvalueLabelTesting: UILabel {
        return arsValueLabel
    }
}


