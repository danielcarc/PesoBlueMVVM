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
    private let distanceService: DistanceServiceProtocol
    weak var appCoordinator: AppCoordinator?
    
    // Guardamos referencia al child para mantenerlo vivo
    private var placeCoordinator: PlaceCoordinator?
    
    init(navigationController: UINavigationController,
         coreDataService: CoreDataServiceProtocol,
         placeService: PlaceServiceProtocol,
         distanceService: DistanceServiceProtocol,
         appCoordinator: AppCoordinator? = nil) {
        self.navigationController = navigationController
        self.coreDataService = coreDataService
        self.placeService = placeService
        self.distanceService = distanceService
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        
        let viewModel = FavoriteViewModel(coreDataService: coreDataService, placeService: placeService, distanceService: distanceService)
        let favoriteView = FavoritesView(viewModel: viewModel) { [weak self] place in
            self?.showPlaceDetail(place)
        }

        let hostingVC = UIHostingController(rootView: favoriteView)
        let title = NSLocalizedString("favorites_title", comment: "")
        hostingVC.title = title
        hostingVC.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: "heart"), tag: 2)
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
