//
//  PesobluTests.swift
//  PesobluTests
//
//  Created by Daniel Carcacha on 10/02/2025.
//

import XCTest
import UIKit
import Foundation
@testable import Pesoblu

final class HomeViewControllerTests: XCTestCase {
    private var sut: HomeViewController!
    private let mockViewModel = MockHomeViewModel()
    private var citysCView: CitysCollectionView!
    private var discoverBaCView: DiscoverBaCollectionView!
    private var quickConversorView: QuickConversorView!
    
    override func setUp() {
        super.setUp()
        citysCView = CitysCollectionView(homeViewModel: mockViewModel)
        discoverBaCView = DiscoverBaCollectionView(homeViewModel: mockViewModel)
        quickConversorView = QuickConversorView()
        sut = HomeViewController(homeViewModel: mockViewModel, quickConversorView: quickConversorView, discoverBaCView: discoverBaCView)
        _ = sut.view // Carga la vista
    }
    
    override func tearDown() {
        sut = nil
        citysCView = nil
        discoverBaCView = nil
        quickConversorView = nil
        super.tearDown()
    }
    
    func test_whenViewLoads_citysCollectionViewsIsNotNil() {
        XCTAssertNotNil(sut.citysCView)
    }
    
    func test_whenViewLoads_discoverCollectionViewsIsNotNil() {
        XCTAssertNotNil(sut.discoverBaCView)
    }
    
    func test_whenViewLoads_quickConversionViewsIsNotNil() {
        XCTAssertNotNil(sut.quickConversorView)
    }
    
    @MainActor
    func test_HomeViewController_shouldBeCitysCviewDelegate() {
        sut.setup() //tuve que cargar primero este metodo que asignaba el delegate
        XCTAssertTrue(sut.citysCView.delegate === sut)
    }
    
    
    func testSetupQuickConversor_Success() async {
        
        await MainActor.run {
            sut.setupQuickConversor()
        }
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 segundos
        await MainActor.run {
            XCTAssertEqual(sut.quickConversorView.usdLabelTesting.text, String(format: NSLocalizedString("currency_format", comment: ""), "1000.00"))
            XCTAssertEqual(sut.quickConversorView.arsvalueLabelTesting.text, String(format: NSLocalizedString("currency_format", comment: ""), "5000.0"))
        }
    }
    
    func testSetupQuickConversor_InvalidURL() async {
        mockViewModel.shouldFail = true
        mockViewModel.apiError = .invalidURL
        await MainActor.run {
            sut.setupQuickConversor()
        }
        try? await Task.sleep(nanoseconds: 500_000_000)
        await MainActor.run {
            XCTAssertEqual(sut.alertMessage, NSLocalizedString("invalid_url_error", comment: ""))
        }
    }
    
    @MainActor
    func testSetupCitysCollectionView_LoadsItems() {
        sut.setupCitysCollectionView()
        XCTAssertEqual(sut.citysCView.collectionViewForTesting.numberOfItems(inSection: 0), 2) // 2 ciudades ficticias
    }
    
    @MainActor
    func testSetupDiscoverCollectionView_LoadsItems() {
        sut.setupDiscoverCollectionView()
        XCTAssertEqual(sut.discoverBaCView.collectionViewForTesting.numberOfItems(inSection: 0), 2) // 2 ítems ficticios
    }
}

class MockHomeViewModel: HomeViewModelProtocol {
    var shouldFail = false
    var apiError: APIError?
    
    func getValueForCountry(countryCode: String) async throws -> String {
        if shouldFail, let error = apiError {
            throw error
        }
        switch countryCode {
        case "AR": return "5000.0" // Ejemplo: 5000 ARS por 1 USD
        case "BR": return "5.0"   // Ejemplo: 5 BRL por 1 USD
        default: return "0.0"
        }
    }
    
    func getDolarBlue() async throws -> Pesoblu.DolarBlue? {
        if shouldFail, let error = apiError {
            throw error
        }
        return Pesoblu.DolarBlue(moneda: "Moneda", casa: "Casa", nombre: "Nombre", compra: 990.0, venta: 1000.0, fechaActualizacion: "") // Dólar blue ficticio
    }
    
    func fetchCitysItems() -> [Pesoblu.CitysItem] {
        return [
            Pesoblu.CitysItem(dict: ["name": "Buenos Aires", "image": "buenos_aires.jpg"]),
            Pesoblu.CitysItem(dict: ["name": "São Paulo", "image": "sao_paulo.jpg"])
        ]
    }
    
    func fetchDiscoverItems() -> [Pesoblu.DiscoverItem] {
        return [
            Pesoblu.DiscoverItem(dict: ["name": "Obelisco", "image": "obelisco.jpg"]),
            Pesoblu.DiscoverItem(dict: ["name": "Avenida Paulista", "image": "avenida_paulista.jpg"])
        ]
    }
    
    func fetchPlaces(city: String) throws -> [Pesoblu.PlaceItem] {
        if shouldFail, let error = apiError {
            throw error
        }
        return [
            Pesoblu.PlaceItem(
                id: 1,
                name: "Casa de Cambio A",
                address: "Calle Falsa 123",
                city: city,
                state: "Capital",
                area: "Centro",
                postalCode: "1234",
                country: "Argentina",
                phone: "123-456-789",
                lat: -34.6037,
                long: -58.3816,
                price: "$100",
                categories: ["Cambio"],
                cuisines: nil,
                instagram: "@casa_cambio_a",
                imageUrl: "casa_a.jpg",
                placeType: .exchange,
                placeDescription: "Casa de cambio en el centro"
            ),
            Pesoblu.PlaceItem(
                id: 2,
                name: "Casa de Cambio B",
                address: "Avenida Siempre Viva 456",
                city: city,
                state: "Capital",
                area: "Microcentro",
                postalCode: "5678",
                country: "Argentina",
                phone: nil,
                lat: -34.6040,
                long: -58.3820,
                price: "$105",
                categories: ["Cambio", "Turismo"],
                cuisines: nil,
                instagram: "@casa_cambio_b",
                imageUrl: "casa_b.jpg",
                placeType: .exchange,
                placeDescription: "Otra casa de cambio"
            )
        ]
    }
    
    func getUserCountry() -> String? {
        return "AR"
    }
}
