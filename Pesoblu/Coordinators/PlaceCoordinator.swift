//
//  PlaceCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 23/07/2025.
//

import UIKit

class PlaceCoordinator: Coordinator{
    var navigationController: UINavigationController
    let coreDataService: CoreDataServiceProtocol
    
    private let place: PlaceItem
    
    init(navigationController: UINavigationController,
         place: PlaceItem,
         coreDataService: CoreDataServiceProtocol) {
        self.navigationController = navigationController
        self.place = place
        self.coreDataService = coreDataService
    }
    
    func start() {
        
        let viewModel = PlaceViewModel(coreDataService: coreDataService, place: place)
        let vc = PlaceViewController(placeViewModel: viewModel, place: place)
        navigationController.pushViewController(vc, animated: true)
    }
}
