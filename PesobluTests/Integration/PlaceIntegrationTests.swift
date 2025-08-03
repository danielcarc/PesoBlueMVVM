//
//  PlaceIntegrationTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 03/08/2025.
//

import XCTest
import CoreData
@testable import Pesoblu

final class PlaceIntegrationTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var service: CoreDataService!
    var viewModel: PlaceViewModel!
    
    override func setUp() {
        super.setUp()
        
        // Stack de CoreData en memoria
        let container = NSPersistentContainer(name: "PesobluModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        let expectation = XCTestExpectation(description: "Load persistent stores")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)

        context = container.viewContext
        service = CoreDataService(context: context)
        
        let fakePlace = PlaceItem(id: 999,
                                  name: "Test Place",
                                  address: "Calle Falsa 123",
                                  city: "Buenos AIRES",
                                  state: "Palermo",
                                  area: "Palermo",
                                  postalCode: "1111",
                                  country: "Argentina",
                                  phone: "https://www.instagram.com/test/",
                                  lat: -34.6037,
                                  long: -58.3816,
                                  price: "$",
                                  categories: ["Bar"],
                                  cuisines: ["Comida"],
                                  instagram: "https://www.instagram.com/test/",
                                  imageUrl: "",
                                  placeType: "",
                                  placeDescription: "")
        
        viewModel = PlaceViewModel(coreDataService: service, place: fakePlace)
    }

    override func tearDown() {
        context = nil
        service = nil
        viewModel = nil
        super.tearDown()
    }

    func test_saveAndLoadFavoriteStatus_shouldReturnTrue() async throws {
        // Given
        try await viewModel.saveFavoriteStatus(isFavorite: true)

        // When
        let isFavorite = try await viewModel.loadFavoriteStatus()

        // Then
        XCTAssertTrue(isFavorite)
    }

    func test_saveAndLoadFavoriteStatus_shouldReturnFalse() async throws {
        // Given
        try await viewModel.saveFavoriteStatus(isFavorite: false)

        // When
        let isFavorite = try await viewModel.loadFavoriteStatus()

        // Then
        XCTAssertFalse(isFavorite)
    }
}
