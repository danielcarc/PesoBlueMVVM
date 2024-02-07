//
//  ViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//


import Foundation

protocol CurrencyViewModelDelegate: AnyObject{
    func didFinish()
    func didFail(error: Error)
}

import Foundation
import UIKit


class CurrencyViewModel{
    
    private var currency : Rates = Rates(BRL: Brl(rate: nil), CLP: Clp(rate: nil), UYU: Uyu(rate: nil))
    
    var currencyArray = ["BRL","CLP","UYU"]

    

    weak var delegate: CurrencyViewModelDelegate?

    
    let currencyUrl = "https://api.getgeoapi.com/v2/currency/convert?api_key="
    let apiKey = "99f81f10b5b6b92679b9051bdce40b7647f150e0"
    

    @MainActor

    func fetchChange(){
        
        Task{
            do{
                guard let url = URL(string: "\(currencyUrl)\(apiKey)&from=USD&to=BRL,UYU,CLP&format=json") else {return}
                
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("error en response")
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                
                self.currency = try jsonDecoder.decode(CurrencyResponse.self, from: data).rates
                self.delegate?.didFinish()
                print(currency)
            }
            catch{
                self.delegate?.didFail(error: error)
                print(error.localizedDescription)
            }
        }
    }
    
    func getTextForPicker(row: Int)-> String{
        switch row {
        case 0:
            return "Real Brasil"
        case 1:
            return "Peso Chile"
        case 2:
            return "Peso Uruguay"
        default:
            return "error"
        }
    }

    
    func convertCurrency(quantityTextField: UITextField, currencyTextField: UITextField, segcontrol: Int){
        let quantity = quantityTextField.text
        let currencyText = Double(valueForCurrency(currencyText: currencyTextField))
        print(currencyText as Any)
    }
    
    func valueForCurrency(currencyText: UITextField) -> String{
        switch currencyText.text {
        case "Real Brasil":
            //guard var currencyValue = Double(currency.BRL.rate ?? "") else { return 0.0 }
            return currency.BRL.rate ?? "0.0"
        case "Peso Chile":
            return currency.CLP.rate ?? "0.0"
        case "Peso Uruguay":
            return currency.UYU.rate ?? "0.0"
        default:
            return "0.00"
        }
    }
    
}


