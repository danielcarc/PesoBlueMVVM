//
//  FavoriteCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 21/07/2025.
//

import UIKit
import SwiftUI

class FavoriteCoordinator: Coordinator{
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        //let place: PlaceItem
        let favoriteView = FavoritesView()
        
        let hostingVC = UIHostingController(rootView: favoriteView)
        hostingVC.title = "Favoritos"
        hostingVC.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "heart"), tag: 2)
        navigationController.setViewControllers([hostingVC], animated: true)
    }
}
