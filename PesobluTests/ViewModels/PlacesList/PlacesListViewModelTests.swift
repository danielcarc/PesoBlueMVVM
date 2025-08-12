//
//  PlacesListViewModelTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 12/08/2025.
//

import XCTest
import CoreLocation
@testable import Pesoblu

final class PlacesListViewModelTests: XCTestCase {
    // MARK: - Mocks
    final class MockDistanceService: DistanceServiceProtocol {
        var calculateDistanceCalled = false
        var getDistanceCalled = false
        var distanceReturnValue = ""

        func calculateDistance(from userLocation: CLLocation, to place: PlaceItem) -> String {
            calculateDistanceCalled = true
            return distanceReturnValue
        }

        func getDistanceForPlace(_ place: PlaceItem) -> String {
            getDistanceCalled = true
            return distanceReturnValue
        }
    }

    final class MockFilterDataService: FilterDataServiceProtocol {
        func fetch() -> [DiscoverItem] { return [] }
    }

    // MARK: - Tests
    func test_getDistanceForPlace_returnsServiceValue() {
        // Given
        let distanceService = MockDistanceService()
        distanceService.distanceReturnValue = "100 m"
        let sut = PlacesListViewModel(distanceService: distanceService,
                                      filterDataService: MockFilterDataService())
        let place = PlaceItem(id: 1,
                              name: "Test",
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

        // When
        let result = sut.getDistanceForPlace(place)

        // Then
        XCTAssertTrue(distanceService.getDistanceCalled)
        XCTAssertEqual(result, "100 m")
    }

    func test_filterData_returnsOnlyMatchingType() {
        // Given
        let sut = PlacesListViewModel(distanceService: MockDistanceService(),
                                      filterDataService: MockFilterDataService())
        let place1 = PlaceItem(id: 1,
                               name: "A",
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
        let place2 = PlaceItem(id: 2,
                               name: "B",
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
                               placeType: .bar,
                               placeDescription: "")
        let places = [place1, place2]

        // When
        let filtered = sut.filterData(places: places, filter: .bar)

        // Then
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.id, place2.id)
    }
}
