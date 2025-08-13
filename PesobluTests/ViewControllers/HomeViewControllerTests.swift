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
    private var citiesCView: CitiesCollectionView!
    private var discoverBaCView: DiscoverBaCollectionView!
    private var quickConversorView: QuickConversorView!
    private var mockAlertPresenter: MockAlertPresenter!
    
    override func setUp() {
        super.setUp()
        citiesCView = CitiesCollectionView(homeViewModel: mockViewModel)
        discoverBaCView = DiscoverBaCollectionView(homeViewModel: mockViewModel)
        quickConversorView = QuickConversorView()
        mockAlertPresenter = MockAlertPresenter()
        sut = HomeViewController(homeViewModel: mockViewModel,
                                 quickConversorView: quickConversorView,
                                 discoverBaCView: discoverBaCView,
                                 alertPresenter: mockAlertPresenter)
    }
    
    override func tearDown() {
        sut = nil
        citiesCView = nil
        discoverBaCView = nil
        quickConversorView = nil
        mockAlertPresenter = nil
        super.tearDown()
    }
    
    func test_whenViewLoads_citiesCollectionViewsIsNotNil() {
        XCTAssertNotNil(sut.citiesCView)
    }
    
    func test_whenViewLoads_discoverCollectionViewsIsNotNil() {
        XCTAssertNotNil(sut.discoverBaCView)
    }
    
    func test_whenViewLoads_quickConversionViewsIsNotNil() {
        XCTAssertNotNil(sut.quickConversorView)
    }
    
    @MainActor
    func test_HomeViewController_shouldBeCitiesCviewDelegate() {
        sut.setup() //tuve que cargar primero este metodo que asignaba el delegate
        XCTAssertTrue(sut.citiesCView.delegate === sut)
    }
    
    
    @MainActor
    func testSetupQuickConversor_Success() {
        let exp = expectation(description: "Quick conversor updates labels")
        
        let expectedUSD = String(format: NSLocalizedString("currency_format", comment: ""), "1000.00")
        let expectedARS = String(format: NSLocalizedString("currency_format", comment: ""), "5000.00")
        mockViewModel.onGetValueForCountryCalled = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                XCTAssertEqual(self.sut.quickConversorView.usdLabelTesting.text, expectedUSD)
                XCTAssertEqual(self.sut.quickConversorView.arsvalueLabelTesting.text, expectedARS)
                exp.fulfill()
            }
        }

        sut.loadViewIfNeeded()

        wait(for: [exp], timeout: 2.0)
    }



    @MainActor
    func testSetupQuickConversor_InvalidURL() {
        // Configuro mock para fallar con invalidURL
        mockViewModel.shouldFail = true
        mockViewModel.apiError = .invalidURL
        let expectation = expectation(description: "Invalid URL shows alert")
        expectation.assertForOverFulfill = true

        mockViewModel.onGetDolarBlueCalled = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertEqual(self.mockAlertPresenter.lastMessage, NSLocalizedString("invalid_url_error", comment: ""))
                expectation.fulfill()
            }
        }

        sut.setupQuickConversor()

        wait(for: [expectation], timeout: 2.0)
    }
    
    @MainActor
    func testCitiesCollectionView_LoadDataLoadsItems() {
        sut.citiesCView.loadData()
        XCTAssertEqual(sut.citiesCView.collectionViewForTesting.numberOfItems(inSection: 0), 2) // 2 ciudades ficticias
    }
    
    @MainActor
    func testDiscoverCollectionView_LoadDataLoadsItems() {
        sut.discoverBaCView.loadData()
        XCTAssertEqual(sut.discoverBaCView.collectionViewForTesting.numberOfItems(inSection: 0), 2) // 2 ítems ficticios
    }
}

final class MockAlertPresenter: AlertPresentable {
    var lastMessage: String?

    func show(message: String, on viewController: UIViewController) {
        lastMessage = message
    }
}

class MockHomeViewModel: HomeViewModelProtocol {
    var shouldFail = false
    var apiError: APIError?
    var onGetValueForCountryCalled: (() -> Void)?
    var onGetDolarBlueCalled: (() -> Void)?
    
    func getValueForCountry(countryCode: String) async throws -> String {
        if shouldFail, let error = apiError {
            throw error
        }
        let value: String
        switch countryCode {
        case "AR": value = "5000.0" // Ejemplo: 5000 ARS por 1 USD
        case "BR": value = "5.0"   // Ejemplo: 5 BRL por 1 USD
        default: value = "0.0"
        }
        onGetValueForCountryCalled?()
        return value
    }
    
    func getDolarBlue() async throws -> Pesoblu.DolarBlue? {
        if shouldFail, let error = apiError {
            onGetDolarBlueCalled?()
            throw error
        }
        onGetDolarBlueCalled?()
        return Pesoblu.DolarBlue(moneda: "Moneda", casa: "Casa", nombre: "Nombre", compra: 990.0, venta: 1000.0, fechaActualizacion: "") // Dólar blue ficticio
    }
    
    func fetchCitiesItems() -> [Pesoblu.CitiesItem] {
        return [
            Pesoblu.CitiesItem(dict: ["name": "Buenos Aires", "image": "buenos_aires.jpg"]),
            Pesoblu.CitiesItem(dict: ["name": "São Paulo", "image": "sao_paulo.jpg"])
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
