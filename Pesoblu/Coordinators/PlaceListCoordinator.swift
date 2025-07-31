//
//  PlaceListCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 23/07/2025.
//
import UIKit

class PlaceListCoordinator: Coordinator{
    var navigationController: UINavigationController
    private let placeListViewModel: PlaceListViewModelProtocol
    private let selectedPlaces: [PlaceItem]
    private let selectedCity: String
    private let placeType: String
    private var placeCoordinator: PlaceCoordinator?
    
    init(navigationController: UINavigationController,
         placeListViewModel: PlaceListViewModelProtocol,
         selectedPlaces: [PlaceItem],
         selectedCity: String,
         placeType: String) {
        self.navigationController = navigationController
        self.placeListViewModel = placeListViewModel
        self.selectedPlaces = selectedPlaces
        self.selectedCity = selectedCity
        self.placeType = placeType
    }
    
    func start() {
        let listVC = PlacesListViewController(placeListViewModel: placeListViewModel,
                                              selectedPlaces: selectedPlaces,
                                              selectedCity: selectedCity,
                                              placeType: placeType)
        
        listVC.onSelect = { [weak self] selectedItem in
            self?.showPlaceDetail(for: selectedItem)
        }
        
        navigationController.pushViewController(listVC, animated: true)
    }
    
    func showPlaceDetail(for item: PlaceItem) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coreDataService = CoreDataService(context: context)
        
        let coordinator = PlaceCoordinator(navigationController: navigationController,
                                           place: item,
                                           coreDataService: coreDataService)
        
        placeCoordinator = coordinator
        coordinator.start()
    }
    
}
