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
    
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func fetchPlaces(city: String) throws -> [PlaceItem] {
        guard let url = bundle.url(forResource: city, withExtension: "json") else {
            
            AppLogger.error("No se encontró el archivo CABA.json")
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
            AppLogger.error(error.localizedDescription)
            throw PlaceError.failedToParseData
        }
        
        guard !places.isEmpty else {
            throw PlaceError.noPlacesAvailable
        }
        return places
        
    }
}
