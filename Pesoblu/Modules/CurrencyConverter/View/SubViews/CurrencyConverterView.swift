//
//  CurrencyView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 24/10/23.
//

import UIKit
import Combine

private struct ConversionTitles {
    let toPeso: String
    let fromPeso: String
    let toDolar: String
    let fromDolar: String
}

///una vez que sea funcional subir el titilelabel arriba y el valuelabel bajarlo asi no se chocan los caracteres, y darle colores a los distintos caracteres para que no sea aburrido

final class CurrencyConverterView: UIView  {
        
    var onAmountChanged: ((Double?) -> Void)?
    private var selectedCurrency: String = ""

    private static let currencyTitles: [String: ConversionTitles] = {
        var dict: [String: ConversionTitles] = [:]
        for code in CurrencyCode.allCases {
            dict[code.rawValue] = ConversionTitles(
                toPeso: NSLocalizedString("currency.\(code.rawValue).toPeso", comment: ""),
                fromPeso: NSLocalizedString("currency.\(code.rawValue).fromPeso", comment: ""),
                toDolar: NSLocalizedString("currency.\(code.rawValue).toDolar", comment: ""),
                fromDolar: NSLocalizedString("currency.\(code.rawValue).fromDolar", comment: "")
            )
        }
        return dict
    }()
    
    init() {
        
        super.init(frame: .zero)
        
        setup()
        quantitytextfield.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    var currencyFromPeso: String = "0.0"
    var currencyToPeso: String = "0.0"
    var currencyToDolar: String = "0.0"
    var currencyToDolarValue: String = "0.0"
    
    private lazy var quantitytextfield : UITextField = {
        var text = UITextField()
        text.placeholder = NSLocalizedString("currency_converter_amount_placeholder", comment: "")
        text.textAlignment = .center
        text.textColor = .label
        text.backgroundColor = .secondarySystemBackground
        text.layer.cornerRadius = 10
        text.keyboardType = .decimalPad
        text.font = .systemFont(ofSize: 17)

        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    private lazy var currencyViewLabel: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currencyLabel: UILabel = {
        var text = UILabel()
        text.font = .systemFont(ofSize: 14)
        text.textColor = .label
        text.textAlignment = .center
        text.backgroundColor = .clear

        text.translatesAutoresizingMaskIntoConstraints = false

        return text
    }()
    
    ///vista
    private lazy var toPesoView: UIView = {
        var view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var toPesoTitle: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("buy_label", comment: "")
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var toPesoValue: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("default_amount_value", comment: "")
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    ///otra vista
    private lazy var fromPesoView: UIView = {
        var view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var fromPesoTitle: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("in_dollars_label", comment: "")
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fromPesoValue: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("default_amount_value", comment: "")
        label.textColor = .systemGreen
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    /// otras vistas
    ///vista
    private lazy var toDolarView: UIView = {
        var view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var toDolarTitle: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("buy_label", comment: "")
        label.textColor = .systemIndigo
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var toDolarValue: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("default_amount_value", comment: "")
        label.textColor = .systemIndigo
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    ///otra vista
    private lazy var fromDolarView: UIView = {
        var view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var fromDolarTitle: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("in_dollars_label", comment: "")
        label.textColor = .systemOrange
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fromDolarValue: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("default_amount_value", comment: "")
        label.textColor = .systemOrange
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
//MARK: Dismiss Keyboard METHODS
    
    @objc func hideKeyboardWhenTappedAround() {
        //Agrega un gesto de reconocimiento para detectar cuando se toca la pantalla fuera del teclado
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        // Oculta el teclado al tocar la pantalla fuera del campo de texto
        self.endEditing(true)
    }
    
    func resigncurrencytext() {
        currencyLabel.resignFirstResponder()
    }
    
    func resignQuantityText() {
        quantitytextfield.resignFirstResponder()
    }
    
    func updateValues(fromPeso: String, toPeso: String, fromDolar: String, toDolar: String) {
        fromPesoValue.text = fromPeso
        toPesoValue.text = toPeso
        fromDolarValue.text = fromDolar
        toDolarValue.text = toDolar
    }
    
    /// This view is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBackground.cgColor,
            UIColor.secondarySystemBackground.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 0
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyCardShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false 
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 12).cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientBackground()
        applyCardShadow(to: quantitytextfield)
        applyCardShadow(to: currencyViewLabel)
        applyCardShadow(to: toPesoView)
        applyCardShadow(to: fromPesoView)
        applyCardShadow(to: toDolarView)
        applyCardShadow(to: fromDolarView)
    }
    
}

//MARK: - Setup and Constraints Methods

private extension CurrencyConverterView {
    
    func setup() {
        addsubviews()
        setupconstraints()
        setupAmountBinding()
        
    }
    
    private func addsubviews() {
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(quantitytextfield)
        
        self.addSubview(currencyViewLabel)
        currencyViewLabel.addSubview(currencyLabel)
        
        self.addSubview(toPesoView)
        toPesoView.addSubview(toPesoTitle)
        toPesoView.addSubview(toPesoValue)
        
        self.addSubview(fromPesoView)
        fromPesoView.addSubview(fromPesoTitle)
        fromPesoView.addSubview(fromPesoValue)
        
        self.addSubview(toDolarView)
        toDolarView.addSubview(toDolarTitle)
        toDolarView.addSubview(toDolarValue)
        
        self.addSubview(fromDolarView)
        fromDolarView.addSubview(fromDolarTitle)
        fromDolarView.addSubview(fromDolarValue)
        
    }
    
    private func setupAmountBinding() {
        quantitytextfield.addTarget(self, action: #selector(amountTextChanged), for: .editingChanged)
    }
    
    private func setupconstraints() {
        
        NSLayoutConstraint.activate([
            
            quantitytextfield.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 30),
            quantitytextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            quantitytextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            quantitytextfield.heightAnchor.constraint(equalToConstant: 34),
            
            currencyViewLabel.topAnchor.constraint(equalTo: quantitytextfield.bottomAnchor, constant: 16),
            currencyViewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            currencyViewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            currencyViewLabel.heightAnchor.constraint(equalToConstant: 50),
            
            currencyLabel.topAnchor.constraint(equalTo: currencyViewLabel.topAnchor),
            currencyLabel.leadingAnchor.constraint(equalTo: currencyViewLabel.leadingAnchor),
            currencyLabel.trailingAnchor.constraint(equalTo: currencyViewLabel.trailingAnchor),
            currencyLabel.bottomAnchor.constraint(equalTo: currencyViewLabel.bottomAnchor),
            
            toPesoView.topAnchor.constraint(equalTo: currencyViewLabel.bottomAnchor, constant: 16),
            toPesoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            toPesoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toPesoView.heightAnchor.constraint(equalToConstant: 91),
            
            toPesoTitle.leadingAnchor.constraint(equalTo: toPesoView.leadingAnchor, constant: 16),
            toPesoTitle.topAnchor.constraint(equalTo: toPesoView.topAnchor, constant: 16),
            
            toPesoValue.bottomAnchor.constraint(equalTo: toPesoView.bottomAnchor, constant: -16),
            toPesoValue.trailingAnchor.constraint(equalTo: toPesoView.trailingAnchor, constant: -16),
            
            fromPesoView.topAnchor.constraint(equalTo: toPesoView.bottomAnchor, constant: 16),
            //sellview.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -12),
            fromPesoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            fromPesoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            fromPesoView.heightAnchor.constraint(equalToConstant: 91),
            
            fromPesoTitle.leadingAnchor.constraint(equalTo: fromPesoView.leadingAnchor, constant: 16),
            fromPesoTitle.topAnchor.constraint(equalTo: fromPesoView.topAnchor, constant: 16),
            
            fromPesoValue.bottomAnchor.constraint(equalTo: fromPesoView.bottomAnchor, constant: -16),
            fromPesoValue.trailingAnchor.constraint(equalTo: fromPesoView.trailingAnchor, constant: -16),
            
            ///vista
            toDolarView.topAnchor.constraint(equalTo: fromPesoView.bottomAnchor, constant: 16),
            toDolarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            toDolarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toDolarView.heightAnchor.constraint(equalToConstant: 91),
            
            toDolarTitle.leadingAnchor.constraint(equalTo: toDolarView.leadingAnchor, constant: 16),
            toDolarTitle.topAnchor.constraint(equalTo: toDolarView.topAnchor, constant: 16),
            
            toDolarValue.bottomAnchor.constraint(equalTo: toDolarView.bottomAnchor, constant: -16),
            toDolarValue.trailingAnchor.constraint(equalTo: toDolarView.trailingAnchor, constant: -16),
            
            fromDolarView.topAnchor.constraint(equalTo: toDolarView.bottomAnchor, constant: 16),
            //sellview.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -12),
            fromDolarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            fromDolarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            fromDolarView.heightAnchor.constraint(equalToConstant: 91),
            
            fromDolarTitle.leadingAnchor.constraint(equalTo: fromDolarView.leadingAnchor, constant: 16),
            fromDolarTitle.topAnchor.constraint(equalTo: fromDolarView.topAnchor, constant: 16),
            
            fromDolarValue.bottomAnchor.constraint(equalTo: fromDolarView.bottomAnchor, constant: -16),
            fromDolarValue.trailingAnchor.constraint(equalTo: fromDolarView.trailingAnchor, constant: -16),
        
        ])
    }
    
    @objc private func amountTextChanged(_ sender: UITextField) {
        let amount = Double(sender.text ?? "")
        onAmountChanged?(amount)
    }
}

//MARK: - TextField & PickerView Methods

extension CurrencyConverterView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxCharacters = 10

        let decimalComma = NSLocalizedString("decimal_comma", comment: "")
        let decimalPoint = NSLocalizedString("decimal_point", comment: "")

        // Si el usuario escribe una coma, la reemplazamos por punto
        if string == decimalComma {
            if let currentText = textField.text as NSString? {
                let updatedText = currentText.replacingCharacters(in: range, with: decimalPoint)
                textField.text = updatedText
            }
            return false
        }

        // Validar que el string ingresado contenga solo números o un punto
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: decimalPoint))
        let characterSet = CharacterSet(charactersIn: string)
        let isValidInput = allowedCharacters.isSuperset(of: characterSet)

        // Validar que no haya más de un punto decimal
        if let currentText = textField.text as NSString? {
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            let containsMultipleDots = updatedText.components(separatedBy: decimalPoint).count > 2
            return updatedText.count <= maxCharacters && isValidInput && !containsMultipleDots
        }

        return true
    }
}


//MARK: - Reset Controls

extension CurrencyConverterView {
    
    func resetControls() {
        let defaultAmount = NSLocalizedString("default_amount_value", comment: "")
        toPesoValue.text = defaultAmount
        fromPesoValue.text = defaultAmount
        toDolarValue.text = defaultAmount
        fromDolarValue.text = defaultAmount
    }
    
}

//MARK: - Set Currency Methods

extension CurrencyConverterView {
    
    func setCurrency(currency: CurrencyItem) {
        currencyLabel.text = currency.currencyTitle
        currencyLabel.textColor = .label
        currencyLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        currencyLabel.layer.cornerRadius = 10
        currencyLabel.clipsToBounds = true
        setTitleLabels(currency: currency)
    }
    
    func setTitleLabels(currency: CurrencyItem) {
        selectedCurrency = currency.currencyLabel ?? ""
        guard
            let label = currency.currencyLabel,
            let code = CurrencyCode.allCases.first(where: { $0.label == label })?.rawValue,
            let titles = CurrencyConverterView.currencyTitles[code]
        else {
            applyDefaultTitles()
            return
        }

        toPesoTitle.text = titles.toPeso
        fromPesoTitle.text = titles.fromPeso
        toDolarTitle.text = titles.toDolar
        fromDolarTitle.text = titles.fromDolar
        toDolarView.isHidden = false
        fromDolarView.isHidden = false
    }

    private func applyDefaultTitles() {
        toPesoTitle.text = NSLocalizedString("currency.default.toPeso", comment: "")
        fromPesoTitle.text = NSLocalizedString("currency.default.fromPeso", comment: "")
        toDolarTitle.text = NSLocalizedString("currency.default.toDolar", comment: "")
        fromDolarTitle.text = NSLocalizedString("currency.default.fromDolar", comment: "")
        toDolarView.isHidden = true
        fromDolarView.isHidden = true
    }
}
