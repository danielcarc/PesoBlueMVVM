//
//  PlaceViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 30/01/2025.
//

import Foundation
import UIKit
import CoreData

protocol PlaceViewModelProtocol{
    func saveFavoriteStatus(isFavorite: Bool) async throws
    func loadFavoriteStatus() async throws -> Bool
    
}

final class PlaceViewModel: PlaceViewModelProtocol{
    
    private let coreDataService: CoreDataServiceProtocol
    private let place: PlaceItem
    
    init(coreDataService: CoreDataServiceProtocol, place: PlaceItem){
        self.coreDataService = coreDataService
        self.place = place
    }
    
    func saveFavoriteStatus(isFavorite: Bool) async throws{
        return try await coreDataService.saveFavoriteStatus(placeId: String(place.id), isFavorite: isFavorite)
    }
    
    func loadFavoriteStatus() async throws -> Bool{
        return try await coreDataService.loadFavoriteStatus(placeId: String(place.id))
    }
}
