//
//  CoreDataService.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 30/06/2025.
//
import CoreData
import Foundation

protocol CoreDataServiceProtocol {
    func loadFavoriteStatus(placeId: String) async throws -> Bool
    func saveFavoriteStatus(placeId: String, isFavorite: Bool) async throws
    func fetchAllFavoritesPlaceIds() throws -> [String]
}

final class CoreDataService: CoreDataServiceProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveFavoriteStatus(placeId: String, isFavorite: Bool) async throws {
        try await context.perform {
            let fetchRequest: NSFetchRequest<FavoritePlace> = FavoritePlace.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "placeId == %@", placeId)

            let results = try self.context.fetch(fetchRequest)

            if let existing = results.first {
                existing.isFavorite = isFavorite
            } else {
                let newFavorite = FavoritePlace(context: self.context)
                newFavorite.placeId = placeId
                newFavorite.isFavorite = isFavorite
            }

            if self.context.hasChanges {
                try self.context.save()
            }
        }
    }

    func loadFavoriteStatus(placeId: String) async throws -> Bool {
        return try await context.perform {
            let fetchRequest: NSFetchRequest<FavoritePlace> = FavoritePlace.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "placeId == %@", placeId)

            let results = try self.context.fetch(fetchRequest)
            return results.first?.isFavorite ?? false
        }
    }

    func fetchAllFavoritesPlaceIds() throws -> [String] {
        let fetchRequest: NSFetchRequest<FavoritePlace> = FavoritePlace.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == YES")

        let results = try context.fetch(fetchRequest)
        return results.compactMap { $0.placeId }
    }
}
