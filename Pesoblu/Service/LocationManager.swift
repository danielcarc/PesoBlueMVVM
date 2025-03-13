//
//  LocationManager.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 21/01/2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var onLocationUpdate: (() -> Void)? // Closure para notificar actualizaciones

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            locationManager.stopUpdatingLocation() // Para no seguir actualizando si no es necesario
            onLocationUpdate?() // Llamar al closure
        }
    }
}


