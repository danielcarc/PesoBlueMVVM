//
//  ViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//

import Foundation

class CurrencyViewModel{
    
    private var currency : Rates = Rates(BRL: Brl(rate: nil), CLP: Clp(rate: nil), UYU: Uyu(rate: nil))
    
    var currencyArray = ["BRL","CLP","UYU"]
    
    
    let currencyUrl = "https://api.getgeoapi.com/v2/currency/convert?api_key="
    let apiKey = "99f81f10b5b6b92679b9051bdce40b7647f150e0"
    
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
                print(currency)
            }
            catch{
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
}


