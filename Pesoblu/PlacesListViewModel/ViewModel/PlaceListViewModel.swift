//
//  PlaceListViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 20/01/2025.
//
import Foundation
import UIKit
import CoreLocation

class PlaceListViewModel{
    
    private var discoverItem: [DiscoverItem] = []
    private var filterManager = FilterDataManager()
    private let locationManager = LocationManager()
    
    func fetchFilterItems() -> [DiscoverItem] {
        
        discoverItem = filterManager.fetch()
        return discoverItem
    }
    
//    func downloadImage(from url: String) async throws -> UIImage {
//        guard let url = URL(string: url) else {
//            throw URLError(.badURL)
//        }
//        
//        let (imageData, response) = try await URLSession.shared.data(from: url)
//        
//        guard let httpResponse = response as? HTTPURLResponse,
//              httpResponse.statusCode == 200 else {
//            throw URLError(.badServerResponse)
//        }
//        
//        guard let image = UIImage(data: imageData) else {
//            throw URLError(.cannotDecodeRawData)
//        }
//        
//        return image
//    }
    
    func calculateDistance(from userLocation: CLLocation, to place: PlaceItem) -> String {
        // Verifica si latitud y longitud tienen valores
        guard let latitude = place.lat, let longitude = place.long else {
            return "Ubicación no disponible"
        }

        let placeLocation = CLLocation(latitude: latitude, longitude: longitude)
        let distanceInMeters = userLocation.distance(from: placeLocation)

        // Convertir a kilómetros y redondear
        if distanceInMeters >= 1000 {
            let distanceInKilometers = distanceInMeters / 1000
            return String(format: "%.1f km", distanceInKilometers)
        } else {
            return String(format: "%.0f m", distanceInMeters)
        }
    }

    
    func getDistanceForPlace(_ place: PlaceItem) -> String {
        guard let userLocation = locationManager.userLocation else {
            return "Calculando..." // Si la ubicación aún no está lista
        }
        return calculateDistance(from: userLocation, to: place)
    }
    
    func filterData(places: [PlaceItem], filter: String) -> [PlaceItem]{
        let place = places
        let type = filter
        let filteredPlaces = place.filter { $0.placeType.lowercased() == type.lowercased() }
        return filteredPlaces
    }
    
}
