//
//  DistanceService.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 27/02/2025.
//
import UIKit
import Foundation
import CoreLocation

protocol DistanceServiceProtocol{
    func calculateDistance(from userLocation: CLLocation, to place: PlaceItem) -> String
    func getDistanceForPlace(_ place: PlaceItem) -> String
}
class DistanceService: DistanceServiceProtocol{
    
    private let locationManager = LocationManager()
    
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
}
