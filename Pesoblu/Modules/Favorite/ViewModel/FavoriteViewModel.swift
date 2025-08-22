//
//  File.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 23/07/2025.
//

import Foundation
import SwiftUI

final class FavoriteViewModel: ObservableObject {
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
    
    func fetchAllFavoritesIds() async throws -> [String] {
        return try coreDataService.fetchAllFavoritesPlaceIds()
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
    
    func loadFavorites() {
        Task {
            do {
                let favoriteIds = try await fetchAllFavoritesIds()
                let allPlaces = try await fetchAllPlaces()
                var filtered = allPlaces.filter { favoriteIds.contains(String($0.id)) }
                for place in filtered {
                    place.distance = distanceService.getDistanceForPlace(place)
                }
                await MainActor.run {
                    self.places = filtered
                }
            } catch {
                AppLogger.error("Error al cargar favoritos: \(error)")
            }
        }
    }
}
