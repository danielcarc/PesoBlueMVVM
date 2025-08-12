//
//  PlacesListCollectionViewModelTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 12/08/2025.
//

import XCTest
import CoreLocation
@testable import Pesoblu

final class PlaceListCollectionViewModelTests: XCTestCase {
    // MARK: - Mock
    final class MockPlacesListViewModel: PlacesListViewModelProtocol {
        var filterDataCalled = false
        var getDistanceForPlaceCalled = false
        var filterReceived: PlaceType?
        var distanceReturnValue = "1 km"

        func getDistanceForPlace(_ place: PlaceItem) -> String {
            getDistanceForPlaceCalled = true
            return distanceReturnValue
        }

        func calculateDistance(from userLocation: CLLocation, to place: PlaceItem) -> String {
            return distanceReturnValue
        }

        func filterData(places: [PlaceItem], filter: PlaceType) -> [PlaceItem] {
            filterDataCalled = true
            filterReceived = filter
            return places.filter { $0.placeType == filter }
        }

        func fetchFilterItems() -> [DiscoverItem] { return [] }
    }

    // MARK: - Tests
    func test_makeItems_filtersAndMapsPlaces() {
        // Given
        let mockViewModel = MockPlacesListViewModel()
        let sut = PlaceListCollectionViewModel(placesListViewModel: mockViewModel)
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
                               price: "10",
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
                               price: "20",
                               categories: nil,
                               cuisines: nil,
                               instagram: "",
                               imageUrl: "",
                               placeType: .bar,
                               placeDescription: "")

        // When
        let items = sut.makeItems(from: [place1, place2], filter: .resto)

        // Then
        XCTAssertTrue(mockViewModel.filterDataCalled)
        XCTAssertEqual(mockViewModel.filterReceived, .resto)
        XCTAssertTrue(mockViewModel.getDistanceForPlaceCalled)
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.title, place1.name)
        XCTAssertEqual(items.first?.price, "10")
        XCTAssertEqual(items.first?.formattedDistance, mockViewModel.distanceReturnValue)
    }
}
