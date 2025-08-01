//
//  CurrencyConverterCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 27/07/2025.
//
import UIKit

final class CurrencyConverterCoordinator: Coordinator{
    var navigationController: UINavigationController
    var currency: CurrencyItem
    
    init(navigationController: UINavigationController, currency: CurrencyItem) {
        self.navigationController = navigationController
        self.currency = currency
    }
    func start() {
        let viewModel = CurrencyConverterViewModel(currencyService: CurrencyService(), notificationService: NotificationService(), selectedCurrency: currency)
        let vc = CurrencyConverterViewController(viewModel: viewModel, currency: currency)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
