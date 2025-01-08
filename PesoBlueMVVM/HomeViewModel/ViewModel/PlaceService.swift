//
//  PlaceService.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 25/12/2024.
//

import Foundation


class PlaceService{
    
    func fetchPlaces() -> [PlaceItem] {
        guard let url = Bundle.main.url(forResource: "CABA", withExtension: "json") else {
            print("No se encontró el archivo CABA.json")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let places = try decoder.decode([PlaceItem].self, from: data)
            return places
        } catch {
            print("Error al cargar o parsear el archivo: \(error)")
            return []
        }
    }
    
    func filterPlaces(by type: String) -> [PlaceItem] {
        let places = fetchPlaces()
        return places.filter { $0.placeType.lowercased() == type.lowercased() }
    }
}
