//
//  CurrencyView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 24/10/23.
//

import UIKit
import Combine


///colocar los 4 valores de la moneda
///borrar sombras y manejarlas de distinta manera o sacarlas
///modificar el Combine para que no se pueda elegir moneda y quede la de la vista
///en el pickerview se actualiza la moneda que va al viewmodel esta el metodo que debemos usar
///hacer que cuando se setea la moneda en esta vista ya vaya colocando los labels como corresponde


final class CurrencyConverterView: UIView {
        
    private var cancellables = Set<AnyCancellable>()
    
    private var viewModel: CurrencyConverterViewModelProtocol
    private var selectedCurrency: String = ""
    
    
    init(frame: CGRect = .zero, currencyConverterViewModel: CurrencyConverterViewModelProtocol) {
        self.viewModel = currencyConverterViewModel
        super.init(frame: frame)
        
        setup()
        quantitytextfield.delegate = self
        setupBindings()
        hideKeyboardWhenTappedAround()
    }
    
    var currencyFromPeso: String = "0.0"
    var currencyToPeso: String = "0.0"
    var pesoToDolar: String = "0.0"
    var currencyToDolarValue: String = "0.0"
    
    private lazy var viewtextseg : UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 213/255.00, green: 229/255.00, blue: 252/255.00, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var quantitytextfield : UITextField = {
        var text = UITextField()
        text.placeholder = "Ingrese la cantidad de dinero a convertir"
        text.textAlignment = .center
        text.textColor = .black
        text.textAlignment = .center
        text.backgroundColor = .white
        text.layer.cornerRadius = 7
        text.keyboardType = .decimalPad
        text.font = .systemFont(ofSize: 17)

        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    
    private lazy var viewpick: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 213/255.00, green: 229/255.00, blue: 252/255.00, alpha: 1)
        view.layer.cornerRadius = 10
//        view.layer.shadowRadius = 3
//        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currencyLabel: UILabel = {
        var text = UILabel()
        //text.placeholder = "Seleccione una moneda para convertir"
        text.font = .systemFont(ofSize: 14)
        text.textColor = .black
        text.textAlignment = .center
        text.backgroundColor = .white
        text.layer.cornerRadius = 5
//        text.layer.shadowRadius = 3
//        text.layer.shadowOpacity = 0.3
        //text.inputView = currencypickerview
        text.isEnabled = true
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    private lazy var valueview: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 213/255.00, green: 229/255.00, blue: 252/255.00, alpha: 1)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var buyview: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buylabel: UILabel = {
        var label = UILabel()
        label.text = "Compra"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var valuebuyview: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var valuebuylabel: UILabel = {
        var label = UILabel()
        label.text = "0.00"
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var sellview: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sellLabel: UILabel = {
        var label = UILabel()
        label.text = "En Dolares"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemGray2
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var valuesellview: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var valuesellLabel: UILabel = {
        var label = UILabel()
        label.text = "0.00"
        label.font = .systemFont(ofSize: 22)
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
    
    @objc func segmentedControlValueChanged(sender: UISegmentedControl){
        let selectedIndex = sender.selectedSegmentIndex
        let textOfCurrency = getTextForCurrency()
        textForBuyLabel(textOfCurrency: textOfCurrency, selectedIndex: selectedIndex)
        
    }
    
    func textForBuyLabel(textOfCurrency: String, selectedIndex: Int){
        switch textOfCurrency {
        case "Real Brasil":
            if selectedIndex == 0 {
                buylabel.text = "En Reales"
                valuebuylabel.text = currencyFromPeso
                valuesellLabel.text = pesoToDolar
            } else if selectedIndex == 1{
                buylabel.text = "En Pesos"
                valuebuylabel.text = currencyToPeso
                valuesellLabel.text = currencyToDolarValue
            }
        case "Peso Chile":
            if selectedIndex == 0 {
                buylabel.text = "Pesos Chile"
                valuebuylabel.text = currencyFromPeso
                valuesellLabel.text = pesoToDolar
            } else if selectedIndex == 1{
                buylabel.text = "En Pesos"
                valuebuylabel.text = currencyToPeso
                valuesellLabel.text = currencyToDolarValue
            }
        case "Peso Uruguay":
            if selectedIndex == 0 {
                buylabel.text = "Pesos Uruguay"
                valuebuylabel.text = currencyFromPeso
                valuesellLabel.text = pesoToDolar
            } else if selectedIndex == 1{
                buylabel.text = "En Pesos"
                valuebuylabel.text = currencyToPeso
                valuesellLabel.text = currencyToDolarValue
            }
        default:
            if selectedIndex == 0 {
                buylabel.text = "error"
            } else if selectedIndex == 1{
                buylabel.text = "error"
            }
        }
    }
    
    @objc func dismissKeyboard() {
        // Oculta el teclado al tocar la pantalla fuera del campo de texto
        self.endEditing(true)
    }

    
    
    func getTextForCurrency() -> String{
        if let text = currencyLabel.text {
            return text
        } else {
            return ""
        }
    }
    
    func setTextForConvertValues(currencyValueFromPeso: String, currencyValueToPeso: String,  dolarValue: String, currencyToDolar: String){
        valuebuylabel.text = currencyValueFromPeso
        valuesellLabel.text = dolarValue
        currencyFromPeso = currencyValueFromPeso
        currencyToPeso = currencyValueToPeso
        pesoToDolar = dolarValue
        currencyToDolarValue = currencyToDolar
    }
    
    
    
    func resigncurrencytext(){
        currencyLabel.resignFirstResponder()
    }
    
    func resignQuantityText(){
        quantitytextfield.resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Setup and Constraints Methods

private extension CurrencyConverterView{
    
    func setup(){
        //self.backgroundColor = .white
        addsubviews()
        setupconstraints()
    }
    
  
    
    private func addsubviews(){
        
        self.backgroundColor = .white
        
        self.addSubview(viewtextseg)
        
        viewtextseg.addSubview(quantitytextfield)
        
        self.addSubview(viewpick)
        
        viewpick.addSubview(currencyLabel)
        
        self.addSubview(valueview)
        
        valueview.addSubview(buyview)
        valueview.addSubview(sellview)
        
        buyview.addSubview(buylabel)
        buyview.addSubview(valuebuyview)
        
        valuebuyview.addSubview(valuebuylabel)
        
        sellview.addSubview(sellLabel)
        sellview.addSubview(valuesellview)
        
        valuesellview.addSubview(valuesellLabel)
    }
    
    private func setupconstraints(){
        
        NSLayoutConstraint.activate([
            viewtextseg.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            viewtextseg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            viewtextseg.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            viewtextseg.heightAnchor.constraint(equalToConstant: 90),
            
            quantitytextfield.topAnchor.constraint(equalTo: viewtextseg.topAnchor, constant: 8),
            quantitytextfield.leadingAnchor.constraint(equalTo: viewtextseg.leadingAnchor, constant: 8),
            quantitytextfield.trailingAnchor.constraint(equalTo: viewtextseg.trailingAnchor, constant: -8),
            quantitytextfield.heightAnchor.constraint(equalToConstant: 34),
            
            viewpick.topAnchor.constraint(equalTo: viewtextseg.bottomAnchor, constant: 16),
            viewpick.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            viewpick.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            viewpick.heightAnchor.constraint(equalToConstant: 50),
            
            currencyLabel.topAnchor.constraint(equalTo: viewpick.topAnchor, constant: 8),
            currencyLabel.leadingAnchor.constraint(equalTo: viewpick.leadingAnchor, constant: 8),
            currencyLabel.trailingAnchor.constraint(equalTo: viewpick.trailingAnchor, constant: -8),
            currencyLabel.heightAnchor.constraint(equalToConstant: 34),
            
            valueview.topAnchor.constraint(equalTo: viewpick.bottomAnchor, constant: 16),
            valueview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            valueview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            valueview.heightAnchor.constraint(equalToConstant: 107),
            
            buyview.topAnchor.constraint(equalTo: valueview.topAnchor, constant: 8),
            buyview.leadingAnchor.constraint(equalTo: valueview.leadingAnchor, constant: 8),
            buyview.widthAnchor.constraint(equalTo: valueview.widthAnchor, multiplier: 0.5, constant: -12),
            buyview.heightAnchor.constraint(equalToConstant: 91),
            
            buylabel.topAnchor.constraint(equalTo: buyview.topAnchor, constant: 8),
            buylabel.centerXAnchor.constraint(equalTo: buyview.centerXAnchor),
            
            valuebuyview.leadingAnchor.constraint(equalTo: buyview.leadingAnchor, constant: 8),
            valuebuyview.trailingAnchor.constraint(equalTo: buyview.trailingAnchor, constant: -8),
            valuebuyview.bottomAnchor.constraint(equalTo: buyview.bottomAnchor, constant: -8),
            valuebuyview.heightAnchor.constraint(equalToConstant: 47),
            
            valuebuylabel.topAnchor.constraint(equalTo: valuebuyview.topAnchor, constant: 8),
            valuebuylabel.leadingAnchor.constraint(equalTo: valuebuyview.leadingAnchor, constant: 8),
            valuebuylabel.trailingAnchor.constraint(equalTo: valuebuyview.trailingAnchor, constant: -8),
            valuebuylabel.bottomAnchor.constraint(equalTo: valuebuyview.bottomAnchor, constant: -8),
            
            sellview.topAnchor.constraint(equalTo: valueview.topAnchor, constant: 8),
            sellview.widthAnchor.constraint(equalTo: valueview.widthAnchor, multiplier: 0.5, constant: -12),
            sellview.trailingAnchor.constraint(equalTo: valueview.trailingAnchor, constant: -8),
            sellview.bottomAnchor.constraint(equalTo: valueview.bottomAnchor, constant: -8),
            
            sellLabel.topAnchor.constraint(equalTo: sellview.topAnchor, constant: 8),
            sellLabel.centerXAnchor.constraint(equalTo: sellview.centerXAnchor),
            
            valuesellview.leadingAnchor.constraint(equalTo: sellview.leadingAnchor, constant: 8),
            valuesellview.trailingAnchor.constraint(equalTo: sellview.trailingAnchor, constant: -8),
            valuesellview.bottomAnchor.constraint(equalTo: sellview.bottomAnchor, constant: -8),
            valuesellview.heightAnchor.constraint(equalToConstant: 47),
            
            valuesellLabel.leadingAnchor.constraint(equalTo: valuesellview.leadingAnchor, constant: 8),
            valuesellLabel.topAnchor.constraint(equalTo: valuesellview.topAnchor, constant: 8),
            valuesellLabel.trailingAnchor.constraint(equalTo: valuesellview.trailingAnchor, constant: -8),
            valuesellLabel.bottomAnchor.constraint(equalTo: valuesellview.bottomAnchor, constant: -8)
        
        ])
    }
}

//MARK: - TextField & PickerView Methods

extension CurrencyConverterView: UITextFieldDelegate{
    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Delegate Methods

extension CurrencyConverterView: CurrencyViewModelDelegate{
    func didFail(error: Error) {
        print(error.localizedDescription)
        //aca colocar un showalert en realidad va en el view controller
    }
    
    func didFinish() async {
        
    }
}

//MARK: - Binding Methods

extension CurrencyConverterView{
    func setupBindings(){
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: quantitytextfield)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .sink { [weak self] text in
                guard let self = self else { return }
                let amount = Double(((text)))
                print("Monto ingresado: \(String(describing: amount))")
                self.viewModel.updateAmount(amount)
                
                if text.isEmpty || amount == nil || amount == 0 {
                    self.resetControls()
                } else {
                    self.setEnableControl()
                }
            }
            .store(in: &cancellables)
        
        viewModel.getConvertedValues()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (currencyFromPeso, currencyToPeso, pesoToDolar, currencyToDolarValue) in
                guard let self = self else { return }
                self.currencyFromPeso = currencyFromPeso
                self.currencyToPeso = currencyToPeso
                self.pesoToDolar = pesoToDolar
                self.currencyToDolarValue = currencyToDolarValue
                self.valuebuylabel.text = currencyFromPeso
                self.valuesellLabel.text = pesoToDolar
                
            }
            .store(in: &cancellables)
    }
    
    func setEnableControl(){
//        currencyLabel.isEnabled = true
//        if currencyLabel.text?.isEmpty ?? true {
//            //currencyLabel.text = "Seleccione una moneda para convertir"
//            //currencyLabel.textColor = .systemRed
//        }
//        currencyLabel.textColor = .systemRed // Añadimos el color aquí también para consistencia
//       // segcontrol.isEnabled = true
//        //segcontrol.selectedSegmentIndex = 0
    }
    
    private func resetControls() {
        buylabel.text = "Compra"
        valuebuylabel.text = "0.00"
        sellLabel.text = "En Dolares"
        valuesellLabel.text = "0.00"
        //viewModel.resetCurrency()
    }
    
}

extension CurrencyConverterView{
    
    func setCurrency(currency: CurrencyItem){
        currencyLabel.text = currency.currencyTitle
        currencyLabel.textColor = .black
        viewModel.updateCurrency(selectedCurrency: currency)
    }
}
