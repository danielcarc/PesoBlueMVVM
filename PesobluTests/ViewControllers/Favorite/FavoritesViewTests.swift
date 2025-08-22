//
//  FavoritesViewTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 22/08/2025.
//

import SwiftUI
import XCTest
@testable import Pesoblu

final class MockFavoriteViewModel: FavoriteViewModelProtocol {
    @Published var places: [PlaceItem] = []
    var ids: [Int] = []
    var items: [PlaceItem] = []

    func fetchAllFavoritesIds() throws -> [Int] { ids }
    func fetchAllPlaces() async throws -> [PlaceItem] { items }

    @MainActor
    func loadFavorites() async {
        let favorites = (try? fetchAllFavoritesIds()) ?? []
        let all = (try? await fetchAllPlaces()) ?? []
        self.places = all.filter { favorites.contains($0.id) }
    }
}


import XCTest
import SwiftUI
import ViewInspector
@testable import Pesoblu

final class FavoritesViewTests: XCTestCase {
    func testRendersFavoritePlaces() throws {
        // VM prepara datos que .task va a usar
        let vm = MockFavoriteViewModel()
        vm.ids = [1, 2]
        vm.items = [
            makePlace(id: 1, name: "One"),
            makePlace(id: 2, name: "Two"),
            makePlace(id: 3, name: "Three")
        ]
        let sut = FavoritesView(viewModel: vm, onSelect: { _ in })
        
        // Montamos la vista para disparar `.task { await vm.loadFavorites() }`
        ViewHosting.host(view: sut)
        defer { ViewHosting.expel() }
        pumpRunLoop(0.1)
        
        // Debe renderizar solo One y Two
        XCTAssertNoThrow(try sut.inspect().find(text: "One"))
        XCTAssertNoThrow(try sut.inspect().find(text: "Two"))
        XCTAssertThrowsError(try sut.inspect().find(text: "Three"))
    }
    
    func testSelectingPlaceTriggersCallback() throws {
        let vm = MockFavoriteViewModel()
        let place = makePlace(id: 10, name: "Ten")
        vm.ids = [10]
        vm.items = [place]
        
        var selected: PlaceItem?
        let sut = FavoritesView(viewModel: vm, onSelect: { selected = $0 })
        
        ViewHosting.host(view: sut)
        defer { ViewHosting.expel() }
        pumpRunLoop(0.1)
        
        // Si FavoritesItemView usa Button, el primer Button debería ser el de la celda
        // Si no, agregá un .accessibilityIdentifier en la celda y buscá por id.
        try sut.inspect().find(ViewType.Button.self).tap()
        XCTAssertEqual(selected?.id, 10)
    }

    func testShowsEmptyStateWhenNoFavorites() throws {
        let vm = MockFavoriteViewModel()
        vm.ids = []
        vm.items = []

        let sut = FavoritesView(viewModel: vm, onSelect: { _ in })

        ViewHosting.host(view: sut)
        defer { ViewHosting.expel() }

        // Esperá a que esté renderizado
        let p = NSPredicate { _, _ in
            (try? sut.inspect()
                .find(ViewType.Text.self, where: { v in
                    (try? v.accessibilityIdentifier()) == "emptyStateText" // 👈 sin .attributes()
                })) != nil
        }
        let exp = expectation(for: p, evaluatedWith: nil)
        wait(for: [exp], timeout: 3.0)
        
        XCTAssertNoThrow(
            try sut.inspect()
                .find(ViewType.Text.self, where: { v in
                    (try? v.accessibilityIdentifier()) == "emptyStateText"
                })
        )
    }

    private func makePlace(id: Int, name: String) -> PlaceItem {
        return PlaceItem(
            id: id,
            name: name,
            address: "Fake Street 123",
            city: "Test City",
            state: "TS",
            area: "Downtown",
            postalCode: "0000",
            country: "Testland",
            phone: nil,
            lat: -34.0,
            long: -58.0,
            price: nil,
            categories: nil,
            cuisines: nil,
            instagram: "@testplace",
            imageUrl: "https://example.com/image.jpg",
            placeType: .resto,
            placeDescription: "A test place for unit testing"
        )
        
    }

    @discardableResult
    private func pumpRunLoop(_ seconds: TimeInterval = 0.05) -> Bool {
        RunLoop.current.run(until: Date().addingTimeInterval(seconds))
        return true
    }

}

