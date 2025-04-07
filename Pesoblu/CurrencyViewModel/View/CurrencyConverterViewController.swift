//
//  CurrencyViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 24/10/23.
//

import UIKit
import Combine
import UserNotifications

final class CurrencyConverterViewController: UIViewController {
    
    var currencyView : CurrencyConverterView?
    let currencyConverterViewModel: CurrencyConverterViewModelProtocol
    
    init(currencyView: CurrencyConverterView? = nil, currencyConverterViewModel: CurrencyConverterViewModelProtocol) {
        self.currencyView = currencyView
        self.currencyConverterViewModel = currencyConverterViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        currencyView = CurrencyConverterView(frame: .zero, currencyConverterViewModel: currencyConverterViewModel)
        self.view = currencyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
}
extension CurrencyConverterViewController{
    
    func setup(){
        title = "Convertir"
        navigationController?.navigationBar.prefersLargeTitles = true
        startTimer()
    }
}

//MARK: - Local Notifications

extension CurrencyConverterViewController{
    
    func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 6000, repeats: true) { timer in
            Task{
                if let dolar = try await self.currencyConverterViewModel.getDolar() {
                    let dolarNow = String(format: "%.2f", dolar.venta)
                    await self.currencyConverterViewModel.checkPermission(dolar: dolarNow)
                }
            }
        }
    }
}
//#Preview("CurrencyViewController", traits: .defaultLayout, body: { CurrencyViewController()})
