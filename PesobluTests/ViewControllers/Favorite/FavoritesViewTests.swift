//
//  FavoritesViewTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 22/08/2025.
//

import XCTest
import SwiftUI
import ViewInspector
import CoreLocation
@testable import Pesoblu

final class FavoritesViewTests: XCTestCase {
    // MARK: - Testable VM
    final class TestFavoriteViewModel: FavoriteViewModel {
        var ids: [Int] = []
        var items: [PlaceItem] = []
        override func fetchAllFavoritesIds() throws -> [Int] { ids }
        override func fetchAllPlaces() async throws -> [PlaceItem] { items }
    }

    final class DummyCoreData: CoreDataServiceProtocol {
        func loadFavoriteStatus(placeId: String) async throws -> Bool { false }
        func saveFavoriteStatus(placeId: String, isFavorite: Bool) async throws {}
        func fetchAllFavoritesPlaceIds() throws -> [String] { [] }
    }
    final class DummyPlace: PlaceServiceProtocol {
        func fetchPlaces(city: String) throws -> [PlaceItem] { [] }
    }
    final class DummyDistance: DistanceServiceProtocol {
        func calculateDistance(from userLocation: CLLocation, to place: PlaceItem) -> String { "" }
        func getDistanceForPlace(_ place: PlaceItem) -> String { "" }
    }

    private func makePlace(id: Int, name: String) -> PlaceItem {
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

    @discardableResult
    private func pumpRunLoop(_ seconds: TimeInterval = 0.05) -> Bool {
        RunLoop.current.run(until: Date().addingTimeInterval(seconds))
        return true
    }

    func testRendersFavoritePlaces() throws {
        let vm = TestFavoriteViewModel(coreDataService: DummyCoreData(),
                                       placeService: DummyPlace(),
                                       distanceService: DummyDistance())
        vm.ids = [1,2]
        vm.items = [makePlace(id: 1, name: "One"), makePlace(id: 2, name: "Two"), makePlace(id: 3, name: "Three")]
        let sut = FavoritesView(viewModel: vm, onSelect: { _ in })
        ViewHosting.host(view: sut)
        pumpRunLoop()
        defer { ViewHosting.expel() }

        XCTAssertNoThrow(try sut.inspect().find(text: "One"))
        XCTAssertNoThrow(try sut.inspect().find(text: "Two"))
        XCTAssertThrowsError(try sut.inspect().find(text: "Three"))
    }

    func testSelectingPlaceTriggersCallback() throws {
        let vm = TestFavoriteViewModel(coreDataService: DummyCoreData(),
                                       placeService: DummyPlace(),
                                       distanceService: DummyDistance())
        let place = makePlace(id: 10, name: "Ten")
        vm.ids = [10]
        vm.items = [place]
        var selected: PlaceItem?
        let sut = FavoritesView(viewModel: vm, onSelect: { selected = $0 })
        ViewHosting.host(view: sut)
        pumpRunLoop()
        defer { ViewHosting.expel() }

        try sut.inspect().find(ViewType.Button.self).tap()
        XCTAssertEqual(selected?.id, 10)
    }
}

