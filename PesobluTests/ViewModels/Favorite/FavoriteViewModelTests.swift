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
     class MockCoreDataService: CoreDataServiceProtocol {
        var ids: [String] = []
        func loadFavoriteStatus(placeId: String) async throws -> Bool { false }
        func saveFavoriteStatus(placeId: String, isFavorite: Bool) async throws {}
        func fetchAllFavoritesPlaceIds() throws -> [String] { ids }
    }

    final class MockPlaceService: PlaceServiceProtocol {
        // Si querés controlar por ciudad:
        var placesByCity: [String: [PlaceItem]] = [:]
        // Si no te importa la ciudad y querés un set global:
        var allPlaces: [PlaceItem] = []

        func fetchPlaces(city: String) throws -> [PlaceItem] {
            if let specific = placesByCity[city] {
                return specific
            } else {
                return allPlaces
            }
        }
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

    private func makeSUT(
        favoriteIds: [Int],
        placesByCity: [String: [PlaceItem]]? = nil,
        allPlaces: [PlaceItem] = [],
        distance: String = "1 km"
    ) -> (sut: FavoriteViewModel, core: MockCoreDataService, place: MockPlaceService, dist: MockDistanceService) {

        let core = MockCoreDataService()
        core.ids = favoriteIds.map(String.init)

        let place = MockPlaceService()
        if let placesByCity {
            place.placesByCity = placesByCity
        } else {
            place.allPlaces = allPlaces
        }

        let dist = MockDistanceService()
        dist.distance = distance

        let sut = FavoriteViewModel(coreDataService: core, placeService: place, distanceService: dist)
        return (sut, core, place, dist)
    }


    // MARK: - Tests
    func testLoadFavoritesFiltersAndAssignsDistance() async {
        // Given
        let p1 = makePlace(id: 1, name: "First")
        let p2 = makePlace(id: 2, name: "Second")

        // Solo CABA devuelve datos; las demás ciudades estarán vacías
        let (sut, _, _, _) = makeSUT(
            favoriteIds: [1],
            placesByCity: ["CABA": [p1, p2]],
            distance: "5 km"
        )

        // When
        await sut.loadFavorites()

        // Then
        XCTAssertEqual(sut.places.count, 1)
        XCTAssertEqual(sut.places.first?.id, 1)
        XCTAssertEqual(sut.places.first?.distance, "5 km")
    }

    func testLoadFavoritesFiltersOutNonFavorites() async {
        // Given
        let p1 = makePlace(id: 1)
        let p2 = makePlace(id: 2)

        let (sut, _, _, _) = makeSUT(
            favoriteIds: [2],
            placesByCity: ["CABA": [p1, p2]]
        )

        // When
        await sut.loadFavorites()

        // Then
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
