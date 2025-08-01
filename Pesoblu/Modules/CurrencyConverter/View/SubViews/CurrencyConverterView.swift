//
//  CurrencyView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 24/10/23.
//

import UIKit
import Combine


///una vez que sea funcional subir el titilelabel arriba y el valuelabel bajarlo asi no se chocan los caracteres, y darle colores a los distintos caracteres para que no sea aburrido

final class CurrencyConverterView: UIView {
        
    var onAmountChanged: ((Double?) -> Void)?
    private var selectedCurrency: String = ""
    
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
        text.placeholder = "Ingrese la cantidad de dinero a convertir"
        text.textAlignment = .center
        text.textColor = .black
        text.backgroundColor = .white
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currencyLabel: UILabel = {
        var text = UILabel()
        text.font = .systemFont(ofSize: 14)
        text.textColor = .black
        text.textAlignment = .center
        text.backgroundColor = .white
        
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    ///vista
    private lazy var toPesoView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var toPesoTitle: UILabel = {
        var label = UILabel()
        label.text = "Compra"
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var toPesoValue: UILabel = {
        var label = UILabel()
        label.text = "0.00"
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    ///otra vista
    private lazy var fromPesoView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var fromPesoTitle: UILabel = {
        var label = UILabel()
        label.text = "En Dolares"
        label.textColor = .systemGreen
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fromPesoValue: UILabel = {
        var label = UILabel()
        label.text = "0.00"
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
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var toDolarTitle: UILabel = {
        var label = UILabel()
        label.text = "Compra"
        label.textColor = .systemIndigo
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var toDolarValue: UILabel = {
        var label = UILabel()
        label.text = "0.00"
        label.textColor = .systemIndigo
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    ///otra vista
    private lazy var fromDolarView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var fromDolarTitle: UILabel = {
        var label = UILabel()
        label.text = "En Dolares"
        label.textColor = .systemOrange
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fromDolarValue: UILabel = {
        var label = UILabel()
        label.text = "0.00"
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
    
    func resigncurrencytext(){
        currencyLabel.resignFirstResponder()
    }
    
    func resignQuantityText(){
        quantitytextfield.resignFirstResponder()
    }
    
    func updateValues(fromPeso: String, toPeso: String, fromDolar: String, toDolar: String) {
        fromPesoValue.text = fromPeso
        toPesoValue.text = toPeso
        fromDolarValue.text = fromDolar
        toDolarValue.text = toDolar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 236/255, green: 244/255, blue: 255/255, alpha: 1).cgColor,
            UIColor(red: 213/255, green: 229/255, blue: 252/255, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 0
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyCardShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
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

private extension CurrencyConverterView{
    
    func setup(){
        addsubviews()
        setupconstraints()
        setupAmountBinding()
        
    }
    
    private func addsubviews(){
        
        self.backgroundColor = .white
        
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
    
    private func setupconstraints(){
        
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
            toPesoTitle.centerYAnchor.constraint(equalTo: toPesoView.centerYAnchor),
            
            toPesoValue.centerYAnchor.constraint(equalTo: toPesoView.centerYAnchor),
            toPesoValue.trailingAnchor.constraint(equalTo: toPesoView.trailingAnchor, constant: -16),
            
            fromPesoView.topAnchor.constraint(equalTo: toPesoView.bottomAnchor, constant: 16),
            //sellview.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -12),
            fromPesoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            fromPesoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            fromPesoView.heightAnchor.constraint(equalToConstant: 91),
            
            fromPesoTitle.leadingAnchor.constraint(equalTo: fromPesoView.leadingAnchor, constant: 16),
            fromPesoTitle.centerYAnchor.constraint(equalTo: fromPesoView.centerYAnchor),
            
            fromPesoValue.centerYAnchor.constraint(equalTo: fromPesoView.centerYAnchor),
            fromPesoValue.trailingAnchor.constraint(equalTo: fromPesoView.trailingAnchor, constant: -16),
            
            ///vista
            toDolarView.topAnchor.constraint(equalTo: fromPesoView.bottomAnchor, constant: 16),
            toDolarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            toDolarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toDolarView.heightAnchor.constraint(equalToConstant: 91),
            
            toDolarTitle.leadingAnchor.constraint(equalTo: toDolarView.leadingAnchor, constant: 16),
            toDolarTitle.centerYAnchor.constraint(equalTo: toDolarView.centerYAnchor),
            
            toDolarValue.centerYAnchor.constraint(equalTo: toDolarView.centerYAnchor),
            toDolarValue.trailingAnchor.constraint(equalTo: toDolarView.trailingAnchor, constant: -16),
            
            fromDolarView.topAnchor.constraint(equalTo: toDolarView.bottomAnchor, constant: 16),
            //sellview.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -12),
            fromDolarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            fromDolarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            fromDolarView.heightAnchor.constraint(equalToConstant: 91),
            
            fromDolarTitle.leadingAnchor.constraint(equalTo: fromDolarView.leadingAnchor, constant: 16),
            fromDolarTitle.centerYAnchor.constraint(equalTo: fromDolarView.centerYAnchor),
            
            fromDolarValue.centerYAnchor.constraint(equalTo: fromDolarView.centerYAnchor),
            fromDolarValue.trailingAnchor.constraint(equalTo: fromDolarView.trailingAnchor, constant: -16),
        
        ])
    }
    
    @objc private func amountTextChanged(_ sender: UITextField) {
        let amount = Double(sender.text ?? "")
        onAmountChanged?(amount)
    }
}

//MARK: - TextField & PickerView Methods

extension CurrencyConverterView: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//MARK: - Reset Controls

extension CurrencyConverterView{
    
    func resetControls(){
        toPesoValue.text = "0.00"
        fromPesoValue.text = "0.00"
        toDolarValue.text = "0.00"
        fromDolarValue.text = "0.00"
    }
    
}

//MARK: - Set Currency Methods

extension CurrencyConverterView{
    
    func setCurrency(currency: CurrencyItem){
        currencyLabel.text = currency.currencyTitle
        currencyLabel.textColor = .black
        currencyLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        currencyLabel.layer.cornerRadius = 10
        currencyLabel.clipsToBounds = true
        setTitleLabels(currency: currency)
    }
    
    func setTitleLabels(currency: CurrencyItem){
        selectedCurrency = currency.currencyLabel ?? ""
        switch currency.currencyLabel {
        case "Uruguay":
            toPesoTitle.text = "Peso Uruguayo   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Peso Uruguayo"
            toDolarTitle.text = "Peso Uruguayo   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Peso Uruguayo"
        case "Brasil":
            toPesoTitle.text = "Real Brasil   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Real Brasil"
            toDolarTitle.text = "Real Brasil   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Real Brasil"
        case "Chile":
            toPesoTitle.text = "Peso Chileno   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Peso Chileno"
            toDolarTitle.text = "Peso Chileno   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Peso Chileno"
        case "Unión Europea":
            toPesoTitle.text = "Euro   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Euro"
            toDolarTitle.text = "Euro   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Euro"
        case "México":
            toPesoTitle.text = "Peso Mexicano  ⮕  Peso"
            fromPesoTitle.text = "Peso   ⮕   Peso Mexicano"
            toDolarTitle.text = "Peso Mexicano   ⮕ Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Peso Mexicano"
        case "Colombia":
            toPesoTitle.text = "Peso Colombiano   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Peso Colombiano"
            toDolarTitle.text = "Peso Colombiano   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Peso Colombiano"
        case "Reino Unido":
            toPesoTitle.text = "Libra Esterlina   ⮕  Peso"
            fromPesoTitle.text = "Peso   ⮕   Libra Esterlina"
            toDolarTitle.text = "Libra Esterlina   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Libra Esterlina"
        case "Japón":
            toPesoTitle.text = "Yen Japonés   ⮕  Peso"
            fromPesoTitle.text = "Peso   ⮕   Yen Japonés"
            toDolarTitle.text = "Yen Japonés   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Yen Japonés"
        case "Israel":
            toPesoTitle.text = "Shequel Israelí   ⮕  Peso"
            fromPesoTitle.text = "Peso   ⮕   Shequel Israelí"
            toDolarTitle.text = "Shequel Israelí   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Shequel Israelí"
        case "Paraguay":
            toPesoTitle.text = "Guaraní Paraguayo   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Guaraní Paraguayo"
            toDolarTitle.text = "Guaraní Paraguayo   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Guaraní Paraguayo"
        case "Perú":
            toPesoTitle.text = "Sol Peruano   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Sol Peruano"
            toDolarTitle.text = "Sol Peruano   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Sol Peruano"
        case "Rusia":
            toPesoTitle.text = "Rublo Ruso   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Rublo Ruso"
            toDolarTitle.text = "Rublo Ruso   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Rublo Ruso"
        case "Canadá":
            toPesoTitle.text = "Dólar Canadiense   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Dólar Canadiense"
            toDolarTitle.text = "Dólar Canadiense   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Dólar Canadiense"
        case "Bolivia":
            toPesoTitle.text = "Boliviano   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Boliviano"
            toDolarTitle.text = "Boliviano   ⮕   Dólar"
            fromDolarTitle.text = "Dólar   ⮕   Boliviano"
        default:
            toPesoTitle.text = "Dólar   ⮕   Peso"
            fromPesoTitle.text = "Peso   ⮕   Dólar"
            toDolarView.isHidden = true
            fromDolarView.isHidden = true
        }
        
    }
}
