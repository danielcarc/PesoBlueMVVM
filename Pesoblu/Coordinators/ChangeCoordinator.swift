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
        let currencies : [CurrencyItem] = []
        let rates : Rates = Rates()
        
        let viewModel = ChangeViewModel(currencyService: CurrencyService(), currencies: currencies, rates: rates)
        
        //let viewModel = ChangeViewModel(currencyService: CurrencyService(), currencies: [], rates: Rates())
        let vc = ChangeViewController(viewModel: viewModel, changeCView: ChangeCollectionView(viewModel: viewModel))
        vc.title = "Cotización"
        vc.tabBarItem = UITabBarItem(title: "Cotización", image: UIImage(named: "exchange-01"), tag: 1)
        navigationController.setViewControllers([vc], animated: false)
    }
}
