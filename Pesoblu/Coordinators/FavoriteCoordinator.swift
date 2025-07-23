//
//  FavoriteCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 21/07/2025.
//

import UIKit
import SwiftUI
import CoreData

class FavoriteCoordinator: Coordinator{
    
    var navigationController: UINavigationController
    private let coreDataService: CoreDataServiceProtocol
    private let placeService: PlaceServiceProtocol
    weak var appCoordinator: AppCoordinator?
    
    // Guardamos referencia al child para mantenerlo vivo
    private var placeCoordinator: PlaceCoordinator?
    
    init(navigationController: UINavigationController,
         coreDataService: CoreDataServiceProtocol,
         placeService: PlaceServiceProtocol,
         appCoordinator: AppCoordinator? = nil) {
        self.navigationController = navigationController
        self.coreDataService = coreDataService
        self.placeService = placeService
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        
        let viewModel = FavoriteViewModel(coreDataService: coreDataService, placeService: placeService)
        let favoriteView = FavoritesView(viewModel: viewModel) { [weak self] place in
            self?.showPlaceDetail(place)
        }
        
        let hostingVC = UIHostingController(rootView: favoriteView)
        hostingVC.title = "Favoritos"
        hostingVC.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "heart"), tag: 2)
        navigationController.setViewControllers([hostingVC], animated: true)
    }
    
    func showPlaceDetail(_ place: PlaceItem){
        let coordinator = PlaceCoordinator(
            navigationController: navigationController,
            place: place,
            coreDataService: coreDataService
        )
        placeCoordinator = coordinator // mantenerlo vivo
        coordinator.start()
    }
}
