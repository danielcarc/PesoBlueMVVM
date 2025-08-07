// PlaceViewModelTests.swift

import XCTest
@testable import Pesoblu

final class PlaceViewModelTests: XCTestCase {

    // MARK: - Mock

    final class MockCoreDataService: CoreDataServiceProtocol {
        var savedPlaceId: String?
        var savedIsFavorite: Bool?
        var loadResult: Bool = false
        var saveCalled = false
        var loadCalled = false
        
        func saveFavoriteStatus(placeId: String, isFavorite: Bool) async throws {
            saveCalled = true
            savedPlaceId = placeId
            savedIsFavorite = isFavorite
        }

        func loadFavoriteStatus(placeId: String) async throws -> Bool {
            loadCalled = true
            savedPlaceId = placeId
            return loadResult
        }
        
        func fetchAllFavoritesPlaceIds() throws -> [String] {
            return []
        }
    }

    // MARK: - Test
    
    func test_saveFavoriteStatus_callsServiceWithCorrectValues() async {
        // Given
        let mockService = MockCoreDataService()
        let place = PlaceItem(id: 123, name: "Siamo", address: "Palermo", city: "CABA", state: "", area: "", postalCode: "", country: "", phone: "", lat: 54.000, long: 27.000, price: "", categories: [""], cuisines: [""], instagram: "", imageUrl: "", placeType: .resto, placeDescription: "")
        let viewModel = PlaceViewModel(coreDataService: mockService, place: place)
        let placeId = String(place.id)
        let isFavorite = true
        
        // When
        let expectation = expectation(description: "Save favorite status")
        Task {
            try await viewModel.saveFavoriteStatus(isFavorite: isFavorite)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
        
        // Then
        XCTAssertTrue(mockService.saveCalled)
        XCTAssertEqual(mockService.savedPlaceId, placeId)
        XCTAssertEqual(mockService.savedIsFavorite, isFavorite)
    }
    
    func test_loadFavoriteStatus_returnsCorrectValue() async {
        // Given
        let mockService = MockCoreDataService()
        mockService.loadResult = true
        
        let place = PlaceItem(id: 456, name: "otro", address: "Palermo", city: "CABA", state: "", area: "", postalCode: "", country: "", phone: "", lat: 54.000, long: 27.000, price: "", categories: [""], cuisines: [""], instagram: "", imageUrl: "", placeType: .resto, placeDescription: "")
        let viewModel = PlaceViewModel(coreDataService: mockService, place: place)
        
        // When
        let expectation = expectation(description: "Load favorite status")
        var result: Bool?
        Task {
            result = try await viewModel.loadFavoriteStatus()
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
        
        // Then
        XCTAssertTrue(mockService.loadCalled)
        XCTAssertEqual(result, true)
    }
}
