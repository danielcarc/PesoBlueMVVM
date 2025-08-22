//
//  FavoriteViewModelTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 22/08/2025.
//

import XCTest
import CoreLocation
@testable import Pesoblu

final class FavoriteViewModelTests: XCTestCase {
    // MARK: - Mocks
    final class MockCoreDataService: CoreDataServiceProtocol {
        var ids: [String] = []
        func loadFavoriteStatus(placeId: String) async throws -> Bool { false }
        func saveFavoriteStatus(placeId: String, isFavorite: Bool) async throws {}
        func fetchAllFavoritesPlaceIds() throws -> [String] { ids }
    }

    final class MockPlaceService: PlaceServiceProtocol {
        var places: [PlaceItem] = []
        func fetchPlaces(city: String) throws -> [PlaceItem] { places }
    }

    final class MockDistanceService: DistanceServiceProtocol {
        var distance = ""
        func calculateDistance(from userLocation: CLLocation, to place: PlaceItem) -> String { distance }
        func getDistanceForPlace(_ place: PlaceItem) -> String { distance }
    }

    // MARK: - Helpers
    private func makePlace(id: Int, name: String = "A") -> PlaceItem {
        return PlaceItem(id: id,
                         name: name,
                         address: "",
                         city: "",
                         state: "",
                         area: "",
                         postalCode: "",
                         country: "",
                         phone: nil,
                         lat: 0,
                         long: 0,
                         price: nil,
                         categories: nil,
                         cuisines: nil,
                         instagram: "",
                         imageUrl: "",
                         placeType: .resto,
                         placeDescription: "")
    }

    private func makeSUT(favoriteIds: [Int], allPlaces: [PlaceItem], distance: String = "1 km") -> FavoriteViewModel {
        let core = MockCoreDataService(); core.ids = favoriteIds.map(String.init)
        let place = MockPlaceService(); place.places = allPlaces
        let dist = MockDistanceService(); dist.distance = distance
        return FavoriteViewModel(coreDataService: core, placeService: place, distanceService: dist)
    }

    // MARK: - Tests
    func testLoadFavoritesFiltersAndAssignsDistance() async {
        let p1 = makePlace(id: 1, name: "First")
        let p2 = makePlace(id: 2, name: "Second")
        let sut = makeSUT(favoriteIds: [1], allPlaces: [p1, p2], distance: "5 km")

        await sut.loadFavorites()

        XCTAssertEqual(sut.places.count, 1)
        XCTAssertEqual(sut.places.first?.id, 1)
        XCTAssertEqual(sut.places.first?.distance, "5 km")
    }

    func testLoadFavoritesFiltersOutNonFavorites() async {
        let p1 = makePlace(id: 1)
        let p2 = makePlace(id: 2)
        let sut = makeSUT(favoriteIds: [2], allPlaces: [p1, p2])

        await sut.loadFavorites()

        XCTAssertEqual(sut.places.map { $0.id }, [2])
    }

    func testLoadFavoritesOnErrorKeepsPlacesEmpty() async {
        final class FailingCoreData: MockCoreDataService {
            override func fetchAllFavoritesPlaceIds() throws -> [String] { throw NSError(domain: "", code: 1) }
        }
        let core = FailingCoreData();
        let place = MockPlaceService();
        let dist = MockDistanceService();
        let sut = FavoriteViewModel(coreDataService: core, placeService: place, distanceService: dist)

        await sut.loadFavorites()

        XCTAssertTrue(sut.places.isEmpty)
    }
}
