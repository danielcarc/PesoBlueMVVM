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
        cvm.delegate = self
        cvm.fetchChange()
        //cview.currencypickerview.delegate = self
        let pickerView2 = cview.getPickerView()
        pickerView2.delegate = self
        pickerView2.dataSource = self
        cview.hideKeyboardWhenTappedAround()
        cview.setDisableFields()
        //cview.setEmptyQuantityTextField(quantity: quantitytextfield)

        
    }
}


extension CurrencyViewController: UITextFieldDelegate{
    //MARK: - Keyboard dismiss methods
    

    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var quantityTextField = cview.getQuantityTextField()
        cview.setEmptyQuantityTextField(quantity: quantityTextField)
//        print(quantity.text as Any)
        
    }
}

extension CurrencyViewController: CurrencyViewModelDelegate{
    func didFail(error: Error) {
        print(error)
    }
    
    func didFinish() {
        let quantityTextfield = cview.getQuantityTextField()
        let currencyTextField = cview.getCurrencyTextField()
        let segControl = cview.getSelectedSegControl()
        cvm.convertCurrency(quantityTextField: quantityTextfield, currencyTextField: currencyTextField, segcontrol: segControl)
    }
}

extension CurrencyViewController{
    
    
    //func texted
}

//MARK: - UITextFieldDelegate
extension CurrencyViewController: UITextFieldDelegate{
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let quantityTextField = cview.getQuantityTextField()
        cview.setEmptyQuantityTextField(quantity: quantityTextField)
        
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
        
        //currencytextfield.resignFirstResponder()
        
        cview.resigncurrencytext()

        let currencytextfield = cview.getCurrencyTextField()
        currencytextfield.text = cvm.getTextForPicker(row: row)
        //print(currencytextfield.text as Any)
        cview.resigncurrencytext()
        cview.setEnableControl()
        cvm.fetchChange()

        
    }
    
}
//deshabilitar todo hasta no poner cantidad              OK
//luego de elegir la cantidad habilitar uipicker         OK
//luego de elegir uipicker habilitar segcontrol y setear el default en 0  OK
//luego hacer conversiones con el delegate



//#Preview("CurrencyViewController", traits: .defaultLayout, body: { CurrencyViewController()})


