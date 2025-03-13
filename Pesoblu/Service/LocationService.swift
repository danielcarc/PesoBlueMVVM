//
//  LocationService.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 12/02/2025.
//
import Foundation

protocol LocationServiceProtocol {
    func getUserCountry() -> String?
}

class LocationService: LocationServiceProtocol {
    func getUserCountry() -> String? {
        let identifier = Locale.current.identifier
        let components = identifier.split(separator: "_")
        return components.count > 1 ? String(components[1]) : nil
    }
}


