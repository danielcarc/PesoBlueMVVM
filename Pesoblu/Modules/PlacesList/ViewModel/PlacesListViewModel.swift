//
//  PlacesListViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 20/01/2025.
//
import Foundation
import UIKit
import CoreLocation

protocol PlacesListViewModelProtocol {
    func getDistanceForPlace(_ place: PlaceItem) -> String
    func calculateDistance(from userLocation: CLLocation, to place: PlaceItem) -> String
    func filterData(places: [PlaceItem], filter: String) -> [PlaceItem]
    func fetchFilterItems() -> [DiscoverItem]
}
class PlacesListViewModel: PlacesListViewModelProtocol {
    
    private let distanceService: DistanceServiceProtocol
    private let filterDataService: FilterDataServiceProtocol
    
    init(distanceService: DistanceServiceProtocol,
         filterDataService: FilterDataServiceProtocol) {
        self.distanceService = distanceService
        self.filterDataService = filterDataService
    }
    
    func fetchFilterItems() -> [DiscoverItem] {
        return filterDataService.fetch()
    }
    
    func calculateDistance(from userLocation: CLLocation, to place: PlaceItem) -> String {
        distanceService.calculateDistance(from: userLocation, to: place)
    }

    func getDistanceForPlace(_ place: PlaceItem) -> String {
        distanceService.getDistanceForPlace(place)
    }
    
    func filterData(places: [PlaceItem], filter: String) -> [PlaceItem]{
        let place = places
        let type = filter
        let filteredPlaces = place.filter { $0.placeType.lowercased() == type.lowercased() }
        return filteredPlaces
    }
    
}
