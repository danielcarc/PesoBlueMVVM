//
//  PlacesListViewControllerTests.swift
//  PesobluTests
//
//  Created by Daniel Carcacha on 12/08/2025.
//

import Foundation
import XCTest
import CoreLocation
@testable import Pesoblu

final class PlacesListViewControllerTests: XCTestCase {
    private var sut: PlacesListViewController!
    private var mockViewModel: MockPlacesListViewModel!
    private var places: [PlaceItem] = []

    // MARK: - Mock
    final class MockPlacesListViewModel: PlacesListViewModelProtocol {
        var filters: [DiscoverItem] = []
        var filterDataCalled = false
        var lastFilter: PlaceType?

        func getDistanceForPlace(_ place: PlaceItem) -> String { "0 m" }
        func calculateDistance(from userLocation: CLLocation, to place: PlaceItem) -> String { "0 m" }
        func filterData(places: [PlaceItem], filter: PlaceType) -> [PlaceItem] {
            filterDataCalled = true
            lastFilter = filter
            return places.filter { $0.placeType == filter }
        }
        func fetchFilterItems() -> [DiscoverItem] { filters }
    }

    override func setUp() {
        super.setUp()
        mockViewModel = MockPlacesListViewModel()
        let filterResto = DiscoverItem(dict: ["name": "Resto", "image": "resto"])
        let filterBar = DiscoverItem(dict: ["name": "Bar", "image": "bar"])
        mockViewModel.filters = [filterResto, filterBar]

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
        places = [place1, place2]

        sut = PlacesListViewController(placesListViewModel: mockViewModel,
                                       selectedPlaces: places,
                                       selectedCity: "City",
                                       placeType: .all)
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        mockViewModel = nil
        places = []
        super.tearDown()
    }

    func test_viewDidLoad_setsDelegates() {
        let view = sut.view as? PlacesListView
        XCTAssertTrue(view?.filterCView.delegate === sut)
        XCTAssertTrue(view?.placesListCView.delegate === sut)
    }

    func test_didSelectFilter_updatesPlaceData() {
        let view = sut.view as! PlacesListView
        XCTAssertEqual(view.placesListCView.placeData.count, 2)

        let filter = DiscoverItem(dict: ["name": "Resto", "image": "resto"])
        sut.didSelectFilter(filter)

        XCTAssertEqual(sut.placeType, .resto)
        XCTAssertEqual(view.placesListCView.placeData.count, 1)
        XCTAssertTrue(mockViewModel.filterDataCalled)
        XCTAssertEqual(mockViewModel.lastFilter, .resto)
    }
}
