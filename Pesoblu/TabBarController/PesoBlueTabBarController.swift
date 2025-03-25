//
//  PesoBlueTabBarControllerViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 23/04/2024.
//

import UIKit

class PesoBlueTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabs()
    }
    
    private func configureTabs() {
        
        let homeViewModel = HomeViewModel(
            currencyService: CurrencyService(),
            locationService: LocationService(),
            placesService: PlaceService(),
            discoverDataService: DiscoverDataService(),
            cityDataService: CityDataService()
        )
        
        let currencyConverterViewModel = CurrencyConverterViewModel(currencyService: CurrencyService(), notificationService: NotificationService())
            
        
        let vc1 = HomeViewController(homeViewModel: homeViewModel)
        let vc2 = ChangeViewController()
        let vc3 = CurrencyConverterViewController( currencyConverterViewModel: currencyConverterViewModel)
        
        // Set Tab Images
        vc1.tabBarItem.image = UIImage(systemName: "house.fill")
        vc2.tabBarItem.image = UIImage(systemName: "arrow.left.arrow.right.square.fill")
        vc3.tabBarItem.image = UIImage(systemName: "currency.usd.circle.fill")
        
        // Set Titles
        vc1.title = "Cambio"
        vc2.tabBarItem.title = "Calcular"
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        setViewControllers([nav1, nav2, nav3], animated: false)
    }

}
