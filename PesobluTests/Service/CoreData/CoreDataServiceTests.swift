//
//  CoreDataServiceTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 01/08/2025.
//

import XCTest
import CoreData
@testable import Pesoblu

class CoreDataServiceTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    var service: CoreDataService!

    override func setUp() {
        super.setUp()
        // Setup del container en memoria
        persistentContainer = NSPersistentContainer(name: "PesobluModel")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        persistentContainer.persistentStoreDescriptions = [description]

        let expectation = expectation(description: "Load persistent stores")
        persistentContainer.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)

        service = CoreDataService(context: persistentContainer.viewContext)
    }

    override func tearDown() {
        persistentContainer = nil
        service = nil
        super.tearDown()
    }

    func test_saveAndLoadFavoriteStatus_true() async throws {
        // Given
        let placeId = "123"
        let isFavorite = true
        
        // When
        try await service.saveFavoriteStatus(placeId: placeId, isFavorite: isFavorite)
        let result = try await service.loadFavoriteStatus(placeId: placeId)

        // Then
        XCTAssertTrue(result)
    }
    
    func test_saveAndLoadFavoriteStatus_false() async throws {
        // Given
        let placeId = "456"
        let isFavorite = false

        // When
        try await service.saveFavoriteStatus(placeId: placeId, isFavorite: isFavorite)
        let result = try await service.loadFavoriteStatus(placeId: placeId)

        // Then
        XCTAssertFalse(result)
    }

    func test_fetchAllFavoritesPlaceIds_returnsOnlyFavorites() throws {
        // Given
        let context = persistentContainer.viewContext
        let favorite1 = FavoritePlace(context: context)
        favorite1.placeId = "fav1"
        favorite1.isFavorite = true
        
        let favorite2 = FavoritePlace(context: context)
        favorite2.placeId = "fav2"
        favorite2.isFavorite = false
        
        let favorite3 = FavoritePlace(context: context)
        favorite3.placeId = "fav3"
        favorite3.isFavorite = true
        
        try context.save()

        // When
        let result = try service.fetchAllFavoritesPlaceIds()

        // Then
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.contains("fav1"))
        XCTAssertTrue(result.contains("fav3"))
        XCTAssertFalse(result.contains("fav2"))
    }
}
