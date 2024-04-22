//
//  ViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//


import Foundation

protocol CurrencyViewModelDelegate: AnyObject{
    func didFinish() async
    func didFail(error: Error)
}

import Foundation
import UIKit


class CurrencyViewModel{
    
    private var currency : Rates = Rates(BRL: Brl(rate: nil), CLP: Clp(rate: nil), UYU: Uyu(rate: nil))
    private (set) var dolar : ExchangeRate?
    
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
                await self.delegate?.didFinish()
                print(currency)
            }
            catch{
                self.delegate?.didFail(error: error)
                print(error.localizedDescription)
            }
        }
    }
    @MainActor
    func getDolar() async -> ExchangeRate?{
        
        Task{
            do{
                guard let url = URL(string: "https://dolarapi.com/v1/dolares/blue") else {return}
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Error en response")
                    return
                }
                let jsonDecoder = JSONDecoder()
                self.dolar = try jsonDecoder.decode(ExchangeRate.self, from: data)
                //print(self.dolar?.venta as Any)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        return dolar
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

    
    func convertCurrencyToX(quantityText: String, currencyText: String, segcontrol: Int) async -> String {

        let quantity = Double(quantityText)
        let currencyValue = Double(valueForCurrency(currencyText: currencyText))
        var dolarValue: Double = 0.0
        while dolarValue == 0.0 {
            if let exchangeRate = await getDolar() {
                dolarValue = exchangeRate.venta ?? 0.0
            } else {
                do {
                    // Esperamos un período antes de volver a intentar
                    try await Task.sleep(nanoseconds: 100000000) // Espera de 100 milisegundos
                } catch {
                    // Manejar la excepción aquí, si es necesario
                    print("Error al esperar: \(error.localizedDescription)")
                }
            }
        }
        let convertedValue = ((quantity ?? 0.0) / dolarValue) * (currencyValue ?? 0.0)
        
        print(convertedValue)
        return String(format: "%.2f", convertedValue)
    }
    
    func convertDolar(quantity: String) async -> String{
        
        let quantity = Double(quantity) ?? 0.0
        var dolarValue: Double = 0.0
        while dolarValue == 0.0 {
            if let exchangeRate = await getDolar() {
                dolarValue = exchangeRate.venta ?? 0.0
            } else {
                do {
                    // Esperamos un período antes de volver a intentar
                    try await Task.sleep(nanoseconds: 100000000) // Espera de 100 milisegundos
                } catch {
                    // Manejar la excepción aquí, si es necesario
                    print("Error al esperar: \(error.localizedDescription)")
                }
            }
        }
        let dolarConvert = quantity / dolarValue
        print(dolarConvert)
        return String(format: "%.2f", dolarConvert)
    }
    
    func valueForCurrency(currencyText: String) -> String{
        switch currencyText {
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


