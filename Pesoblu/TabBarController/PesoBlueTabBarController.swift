//
//  PesoBlueTabBarControllerViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 23/04/2024.
//

import UIKit
import SwiftUI

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
        
        let userProfileViewModel = UserProfileViewModel(userService: UserService())
        
        let vc1 = HomeViewController(homeViewModel: homeViewModel)
        vc1.title = "Home"
        let vc2 = ChangeViewController()
        vc2.title = "Cotización"
        let userProfileView = UserProfileView(userProfileViewModel: userProfileViewModel)
        let userProfileHostingController = UIHostingController(rootView: userProfileView)
        userProfileHostingController.title = "Perfil"
        
        //set Tab Images
//        vc1.tabBarItem.image = UIImage(systemName: "house.fill")
//        vc2.tabBarItem.image = UIImage(systemName: "arrow.left.arrow.right.square.fill")
//        userProfileHostingController.tabBarItem.image = UIImage(systemName: "currency.usd.circle.fill")
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: userProfileHostingController)
        
        vc1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home-01"), tag: 0)
        vc2.tabBarItem = UITabBarItem(title: "Cotización", image: UIImage(named: "exchange-01"), tag: 1)
        userProfileHostingController.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(named: "user-square"), tag: 2)
        
        setViewControllers([nav1, nav2, nav3], animated: false)
    }

}
