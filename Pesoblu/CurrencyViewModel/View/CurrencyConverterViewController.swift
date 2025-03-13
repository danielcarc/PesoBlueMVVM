//
//  CurrencyViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 24/10/23.
//

import UIKit
import Combine
import UserNotifications

class CurrencyConverterViewController: UIViewController {
    
    var currencyView : CurrencyConverterView!
    
    let cvm = CurrencyConverterViewModel()
    
    override func loadView() {
        currencyView = CurrencyConverterView()
        self.view = currencyView
    }
    
    override func viewDidLoad() {
        
        //aca armar un metodo setup para dejar mas limpio esto
        super.viewDidLoad()
        setup()

    }
}
extension CurrencyConverterViewController{
    func setup(){
       
        //currencyView.hideKeyboardWhenTappedAround()
        //currencyView.setDisableFields()
        title = "Calcular"
        navigationController?.navigationBar.prefersLargeTitles = true
        //setupBindings()
        startTimer()
    }
}

//MARK: - Local Notifications

extension CurrencyConverterViewController{
    
    func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 6000, repeats: true) { timer in
            Task{
                if let dolar = await self.cvm.getDolar() {
                    let dolarNow = String(format: "%.2f", dolar.venta ?? 0.0)
                    await self.cvm.checkPermission(dolar: dolarNow)
                }
            }
        }
    }
}
//#Preview("CurrencyViewController", traits: .defaultLayout, body: { CurrencyViewController()})
