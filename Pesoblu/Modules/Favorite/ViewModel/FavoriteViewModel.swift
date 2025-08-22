//
//  FavoriteViewModel.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 23/07/2025.
//

import Foundation
import SwiftUI

protocol FavoriteViewModelProtocol: ObservableObject {
    var places: [PlaceItem] { get }        // <- exposición solo lectura
    func loadFavorites() async
    func fetchAllFavoritesIds() throws -> [Int]
    func fetchAllPlaces() async throws -> [PlaceItem]
}

final class FavoriteViewModel: FavoriteViewModelProtocol {
    private let coreDataService : CoreDataServiceProtocol
    private let placeService : PlaceServiceProtocol
    private let distanceService: DistanceServiceProtocol
    
    @Published private(set) var places : [PlaceItem] = []
    
    init(coreDataService: CoreDataServiceProtocol,
         placeService: PlaceServiceProtocol,
         distanceService: DistanceServiceProtocol) {
        self.coreDataService = coreDataService
        self.placeService = placeService
        self.distanceService = distanceService
    }
    
    func fetchAllFavoritesIds() throws -> [Int] {
            return try coreDataService.fetchAllFavoritesPlaceIds().compactMap { Int($0) }
    }
    
    func fetchAllPlaces() async throws -> [PlaceItem] {
        var all : [PlaceItem] = []
        let cities = [
            "Bariloche",
            "CABA",
            "Cordoba",
            "El Calafate",
            "Iguazu",
            "Mendoza",
            "Salta",
            "Ushuaia",
            "Villa La Angostura"
        ]
        for city in cities {
            all.append(contentsOf: try placeService.fetchPlaces(city: city))
        }
        return all
    }
    
    @MainActor
    func loadFavorites() async {
        do {
            let favoriteIds = try fetchAllFavoritesIds()
            let allPlaces = try await fetchAllPlaces()
            let filtered = allPlaces
                .filter { favoriteIds.contains($0.id) }
                .map { place -> PlaceItem in
                    place.distance = distanceService.getDistanceForPlace(place)
                    return place
                }
            self.places = filtered
        } catch {
            AppLogger.error("Error al cargar favoritos: \(error)")
        }
    }
}
