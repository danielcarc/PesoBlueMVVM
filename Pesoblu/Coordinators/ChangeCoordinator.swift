//
//  ChangeCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 15/07/2025.
//
import UIKit

class ChangeCoordinator: Coordinator {
    var navigationController: UINavigationController

    init() {
        self.navigationController = UINavigationController()
    }
    
    
    func start() {
        let viewModel = ChangeViewModel(currencyService: CurrencyService(), currencies: [], rates: Rates())
        let vc = ChangeViewController(viewModel: viewModel)
        vc.title = "Cotización"
        vc.tabBarItem = UITabBarItem(title: "Cotización", image: UIImage(named: "exchange-01"), tag: 1)
        navigationController.setViewControllers([vc], animated: false)
    }
}
