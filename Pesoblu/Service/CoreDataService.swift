//
//  CoreDataService.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 30/06/2025.
//
import CoreData
import Foundation
import UIKit

protocol CoreDataServiceProtocol {
    func loadFavoriteStatus(placeId: String) async throws -> Bool
    func saveFavoriteStatus(placeId: String, isFavorite: Bool) async throws
}

class CoreDataService: CoreDataServiceProtocol{
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveFavoriteStatus(placeId: String, isFavorite: Bool) async throws {
        let fetchRequest: NSFetchRequest<FavoritePlace> = FavoritePlace.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "placeId == %@", placeId)
        
        do {
            let results = try self.context.fetch(fetchRequest)
            if let favorite = results.first {
                favorite.isFavorite = isFavorite
            } else {
                let newFavorite = FavoritePlace(context: self.context)
                newFavorite.placeId = placeId
                newFavorite.isFavorite = isFavorite
            }
            try self.context.save()
        }
        catch{
            throw error
        }
    }
    
    func loadFavoriteStatus(placeId: String) async throws -> Bool {
        var results: [FavoritePlace] = []
        do{
            try await context.perform {
                let fetchRequest: NSFetchRequest<FavoritePlace> = FavoritePlace.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "placeId == %@", placeId)
                results = try self.context.fetch(fetchRequest)
            }
        }
        catch{
            throw error
        }
        return results.first?.isFavorite ?? false
    }
}
