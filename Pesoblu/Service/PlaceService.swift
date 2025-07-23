//
//  PlaceService.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 25/12/2024.
//

import Foundation

protocol PlaceServiceProtocol {
    func fetchPlaces(city: String) throws -> [PlaceItem]
}

class PlaceService: PlaceServiceProtocol{
    
    func fetchPlaces(city: String) throws -> [PlaceItem] {
        guard let url = Bundle.main.url(forResource: city, withExtension: "json") else {
            
            print("No se encontró el archivo CABA.json")
            throw PlaceError.fileNotFound
            
        }
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw PlaceError.failedToParseData
        }
        
        let places: [PlaceItem]
        do{
            let decoder = JSONDecoder()
            places = try decoder.decode([PlaceItem].self, from: data)
            
        } catch {
            print(error.localizedDescription)
            throw PlaceError.failedToParseData
        }
        
        guard !places.isEmpty else {
            throw PlaceError.noPlacesAvailable
        }
        return places
        
    }
    
//    func filterPlaces(by type: String) throws -> [PlaceItem] {
//        let places = try fetchPlaces()
//        let filteredPlaces = places.filter { $0.placeType.lowercased() == type.lowercased() }
//        
//        return filteredPlaces
//    }
    
    
}
