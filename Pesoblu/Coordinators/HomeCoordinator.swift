//
//  HomeCoordinator.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 15/07/2025.
//
import UIKit

final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var placesListCoordinator: PlacesListCoordinator?

    init() {
        self.navigationController = UINavigationController()
    }

    func start() {
        let viewModel = HomeViewModel(
            currencyService: CurrencyService(),
            locationService: LocationService(),
            placesService: PlaceService(),
            discoverDataService: DiscoverDataService(),
            cityDataService: CityDataService()
        )
        let vc = HomeViewController(homeViewModel: viewModel)

        vc.setOnSelect { [weak self] selectedPlaces, selectedCity, placeType in
            self?.showPlacesListWithCity(selectedPlaces: selectedPlaces, selectedCity: selectedCity, placeType: placeType)
        }

        let title = NSLocalizedString("home_title", comment: "")
        vc.title = title
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(named: "home-01"), tag: 0)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    func showPlacesListWithCity(selectedPlaces: [PlaceItem], selectedCity: String, placeType: PlaceType){
        
        let viewModel = PlacesListViewModel(distanceService: DistanceService(locationProvider: LocationManager()), filterDataService: FilterDataService())
        let coordinator = PlacesListCoordinator(navigationController: navigationController, placesListViewModel: viewModel, selectedPlaces: selectedPlaces, selectedCity: selectedCity, placeType: placeType)

        placesListCoordinator = coordinator
        coordinator.start()
        
    }
    
}
