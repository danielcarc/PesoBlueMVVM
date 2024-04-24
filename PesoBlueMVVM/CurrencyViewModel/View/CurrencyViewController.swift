//
//  CurrencyViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 24/10/23.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    var cview : CurrencyView!
    
    let cvm = CurrencyViewModel()
    
    override func loadView() {
        cview = CurrencyView()
        self.view = cview
        //var currencytextfield = cview.getCurrencyTextField()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currencytextfield = cview.getCurrencyTextField()
        currencytextfield.delegate = self
        let quantityTextField = cview.getQuantityTextField()
        quantityTextField.delegate = self
        cvm.delegate = self
        //cvm.fetchChange()
        //cview.currencypickerview.delegate = self
        let pickerView2 = cview.getPickerView()
        pickerView2.delegate = self
        pickerView2.dataSource = self
        cview.hideKeyboardWhenTappedAround()
        cview.setDisableFields()
        title = "Calcular"
        navigationController?.navigationBar.prefersLargeTitles = true

    }
}


extension CurrencyViewController: UITextFieldDelegate{
    
    //MARK: - Text Field Methods
    //funcion que me sirve para tomar por parametro tipeado en un textfield y actualiza la variable updatetext
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Concatena el texto existente en el campo de texto con la cadena de reemplazo
        let quantityTextField = cview.getQuantityTextField()
        let updatedText = (cview.getQuantityTextField().text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        //cview.setQuantityText()
        
        if updatedText != cview.getQuantityText(){
            cview.setCurrencyText()
        }
        if quantityTextField.text?.isEmpty ?? true {
            cview.setDisableFields()
        }
//        else {
//            cview.setEnableFields()
//        }
        
        
        
        // Retorna true para permitir que se realice el cambio en el campo de texto
        return true
    }

    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //let quantityTextField = cview.getQuantityTextField()
        //cview.setEmptyQuantityTextField(quantity: quantityTextField)
        //cview.setEnableControl()
//        print(quantity.text as Any)
        
    }
}

extension CurrencyViewController: CurrencyViewModelDelegate{
    func didFail(error: Error) {
        print(error)
    }
    
    func didFinish() async {
        let quantityText = cview.getQuantityText()
        let currencyText = cview.getTextForCurrency()
        let segControl = cview.getSelectedSegControl()
        let (convertCurrencyFromPeso, convertCurrencyToPeso, currencyValueToDolar) = await cvm.convertCurrencyToX(quantityText: quantityText, currencyText: currencyText, segcontrol: segControl)
        let convertDolar = await cvm.convertDolar(quantity: quantityText)
        cview.setTextForConvertValues(currencyValueFromPeso: convertCurrencyFromPeso, currencyValueToPeso: convertCurrencyToPeso, dolarValue: convertDolar, currencyToDolar: currencyValueToDolar)
        //tengo las conversiones, ahora necesito que queden en la UI
        //cview.setTextForConvertLabel(segmentControl: segControl)
    }
}

//MARK: - UIPickerView Delegate and DataSource

extension CurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        cvm.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //var row = cvm.currencyArray[row]
        cvm.getTextForPicker(row: row)

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //var row = cvm.currencyArray[row]
       
        let currencytextfield = cview.getCurrencyTextField()
        currencytextfield.text = cvm.getTextForPicker(row: row)
        print(currencytextfield.text as Any)
        cview.setTextForSegControl(segmentControl: currencytextfield.text ?? "")
        cview.resigncurrencytext()
        cview.setEnableControl()
        cvm.fetchChange()

    }
}

//#Preview("CurrencyViewController", traits: .defaultLayout, body: { CurrencyViewController()})


