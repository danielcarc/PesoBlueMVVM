//
//  CurrencyView.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 24/10/23.
//

import UIKit
import Combine

class CurrencyConverterView: UIView {
    
    private var cvm = CurrencyConverterViewModel()
    private var cancellables = Set<AnyCancellable>()
    
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
        text.textColor = .systemRed
        text.textAlignment = .center
        text.backgroundColor = .white
        text.layer.cornerRadius = 7
        text.keyboardType = .decimalPad
        text.font = .systemFont(ofSize: 17)

        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    private lazy var segcontrol: UISegmentedControl = {
        var control = UISegmentedControl()
        control.insertSegment(withTitle: "$ -> Moneda", at: 0, animated: false)
        control.insertSegment(withTitle: "Moneda -> $", at: 1, animated: false)
        control.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        control.isMultipleTouchEnabled = false
        control.isEnabled = false
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }()
    
    private lazy var viewpick: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 213/255.00, green: 229/255.00, blue: 252/255.00, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currencypickerview: UIPickerView = {
        var picker = UIPickerView()
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var currencytextfield: UITextField = {
        var text = UITextField()
        text.placeholder = "Seleccione una moneda para convertir"
        text.font = .systemFont(ofSize: 14)
        text.textColor = .red
        text.textAlignment = .center
        text.backgroundColor = .white
        text.layer.cornerRadius = 5
        text.layer.shadowRadius = 3
        text.layer.shadowOpacity = 0.3
        text.inputView = currencypickerview
        text.isEnabled = false
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

    func setEnableControl(){
        currencytextfield.isEnabled = true
        if currencytextfield.text?.isEmpty ?? true {
            currencytextfield.text = "Seleccione una moneda para convertir"
            currencytextfield.textColor = .systemRed
        }
        currencytextfield.textColor = .systemRed // Añadimos el color aquí también para consistencia
        segcontrol.isEnabled = true
        segcontrol.selectedSegmentIndex = 0
    }
    
    func getTextForCurrency() -> String{
        if let text = currencytextfield.text {
            return text
        } else {
            return ""
        }
    }
    
    func setTextForSegControl(segmentControl: String){
        switch segmentControl {
        case "Real Brasil":
            segcontrol.setTitle("$ -> Reales", forSegmentAt: 0)
            segcontrol.setTitle("Reales -> $", forSegmentAt: 1)
            buylabel.text = "En Reales"
            
        case "Peso Chile":
            segcontrol.setTitle("$ -> Peso Chile", forSegmentAt: 0)
            segcontrol.setTitle("Peso Chile -> $", forSegmentAt: 1)
            buylabel.text = "Pesos Chile"
        case "Peso Uruguay":
            segcontrol.setTitle("$ -> Peso Uruguay", forSegmentAt: 0)
            segcontrol.setTitle("Peso Uruguay -> $", forSegmentAt: 1)
            buylabel.text = "Pesos Uruguay"
        default:
            segcontrol.setTitle("error", forSegmentAt: 0)
            segcontrol.setTitle("error", forSegmentAt: 1)
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        currencypickerview.delegate = self
        currencypickerview.dataSource = self
        cvm.delegate = self
        quantitytextfield.delegate = self
        currencytextfield.delegate = self
        setupBindings()
        hideKeyboardWhenTappedAround()
    }
    
    func resigncurrencytext(){
        currencytextfield.resignFirstResponder()
    }
    
    func resignQuantityText(){
        quantitytextfield.resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CurrencyConverterView{
    
    func setup(){
        //self.backgroundColor = .white
        addsubviews()
        setupconstraints()
    }
    
    //MARK: - Setup and Constraints Methods
    
    private func addsubviews(){
        
        self.backgroundColor = .white
        
        self.addSubview(viewtextseg)
        
        viewtextseg.addSubview(quantitytextfield)
        viewtextseg.addSubview(segcontrol)
        
        self.addSubview(viewpick)
        
        viewpick.addSubview(currencytextfield)
        
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
            
            segcontrol.topAnchor.constraint(equalTo: quantitytextfield.bottomAnchor, constant: 8),
            segcontrol.leadingAnchor.constraint(equalTo: viewtextseg.leadingAnchor, constant: 8),
            segcontrol.trailingAnchor.constraint(equalTo: viewtextseg.trailingAnchor, constant: -8),
            segcontrol.bottomAnchor.constraint(equalTo: viewtextseg.bottomAnchor, constant: -8),
            
            viewpick.topAnchor.constraint(equalTo: viewtextseg.bottomAnchor, constant: 16),
            viewpick.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            viewpick.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            viewpick.heightAnchor.constraint(equalToConstant: 50),
            
            currencytextfield.topAnchor.constraint(equalTo: viewpick.topAnchor, constant: 8),
            currencytextfield.leadingAnchor.constraint(equalTo: viewpick.leadingAnchor, constant: 8),
            currencytextfield.trailingAnchor.constraint(equalTo: viewpick.trailingAnchor, constant: -8),
            currencytextfield.heightAnchor.constraint(equalToConstant: 34),
            
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

extension CurrencyConverterView: UITextFieldDelegate{
    
    //MARK: - TextField & PickerView Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension CurrencyConverterView: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        cvm.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        cvm.getTextForPicker(row: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("moneda seleccionada: \(cvm.currencyArray[row])")
        cvm.updateCurrency(currency: cvm.currencyArray[row])
        currencytextfield.text = cvm.getTextForPicker(row: row)
        setTextForSegControl(segmentControl: currencytextfield.text ?? "")
        currencytextfield.resignFirstResponder()
        setEnableControl()
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
                let amount = Double(text)
                print("Monto ingresado: \(String(describing: amount))")
                self.cvm.updateAmount(amount)
                
                if text.isEmpty || amount == nil || amount == 0 {
                    self.resetControls()
                } else {
                    self.setEnableControl()
                }
            }
            .store(in: &cancellables)
        
        cvm.convertedValues
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
    
    private func resetControls() {
        currencytextfield.isEnabled = false
        currencytextfield.text = nil
        currencytextfield.placeholder = "Seleccione una moneda para convertir"
        currencypickerview.selectRow(0, inComponent: 0, animated: false)
        segcontrol.isEnabled = false
        segcontrol.setTitle("$ -> Moneda", forSegmentAt: 0)
        segcontrol.setTitle("Moneda -> $", forSegmentAt: 1)
        buylabel.text = "Compra"
        valuebuylabel.text = "0.00"
        sellLabel.text = "En Dolares"
        valuesellLabel.text = "0.00"
        cvm.resetCurrency()
    }
    
}
