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
    func saveFavoriteStatus(placeId: String, isFavorite: Bool) async throws
    func loadFavoriteStatus(placeId: String) async throws -> Bool
    
}

class PlaceViewModel: PlaceViewModelProtocol{
    
    private var coreDataService: CoreDataServiceProtocol
    
    init(coreDataService: CoreDataServiceProtocol){
        self.coreDataService = coreDataService
    }
    
    func saveFavoriteStatus(placeId: String, isFavorite: Bool) async throws{
        return try await coreDataService.saveFavoriteStatus(placeId: placeId, isFavorite: isFavorite)
    }
    
    func loadFavoriteStatus(placeId: String) async throws -> Bool{
        //var isFavorite: Bool = false
        return try await coreDataService.loadFavoriteStatus(placeId: placeId)
    }
    

}
