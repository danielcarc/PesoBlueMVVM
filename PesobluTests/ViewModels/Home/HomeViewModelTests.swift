//
//  HomeViewModelTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 19/08/2025.
//

import XCTest
@testable import Pesoblu

final class HomeViewModelTests: XCTestCase {
    // MARK: - Mocks
    enum MockError: Error { case failure }

    final class MockCurrencyService: CurrencyServiceProtocol {
        var dolarBlueResult: Result<DolarBlue?, Error> = .success(nil)
        var valueForCountryResult: Result<String, Error> = .success("")

        func getDolarBlue() async throws -> DolarBlue? {
            switch dolarBlueResult {
            case .success(let value):
                return value
            case .failure(let error):
                throw error
            }
        }

        func getValueForCountry(countryCode: String) async throws -> String {
            switch valueForCountryResult {
            case .success(let value):
                return value
            case .failure(let error):
                throw error
            }
        }

        func getDolarOficial() async throws -> DolarOficial? { nil }
        func getDolarMep() async throws -> DolarMEP? { nil }
        func getChangeOfCurrencies() async throws -> Rates { Rates() }
    }

    final class MockLocationService: LocationServiceProtocol {
        var country: String?
        func getUserCountry() -> String? { country }
    }

    final class MockPlaceService: PlaceServiceProtocol {
        var fetchResult: Result<[PlaceItem], Error> = .success([])
        func fetchPlaces(city: String) throws -> [PlaceItem] {
            switch fetchResult {
            case .success(let value):
                return value
            case .failure(let error):
                throw error
            }
        }
    }

    final class MockDiscoverDataService: DiscoverDataServiceProtocol {
        var items: [DiscoverItem] = []
        func fetch() -> [DiscoverItem] { items }
    }

    final class MockCityDataService: CityDataServiceProtocol {
        var items: [CitiesItem] = []
        func fetch() -> [CitiesItem] { items }
    }

    // MARK: - Properties
    var viewModel: HomeViewModel!
    var currencyService: MockCurrencyService!
    var locationService: MockLocationService!
    var placeService: MockPlaceService!
    var discoverDataService: MockDiscoverDataService!
    var cityDataService: MockCityDataService!

    override func setUp() {
        super.setUp()
        currencyService = MockCurrencyService()
        locationService = MockLocationService()
        placeService = MockPlaceService()
        discoverDataService = MockDiscoverDataService()
        cityDataService = MockCityDataService()
        viewModel = HomeViewModel(currencyService: currencyService,
                                  locationService: locationService,
                                  placesService: placeService,
                                  discoverDataService: discoverDataService,
                                  cityDataService: cityDataService)
    }

    override func tearDown() {
        viewModel = nil
        currencyService = nil
        locationService = nil
        placeService = nil
        discoverDataService = nil
        cityDataService = nil
        super.tearDown()
    }

    // MARK: - Tests
    func testGetDolarBlueSuccess() async throws {
        let expected = DolarBlue(moneda: "USD", casa: "Blue", nombre: "Blue", compra: 100, venta: 105, fechaActualizacion: "2025")
        currencyService.dolarBlueResult = .success(expected)

        let result = try await viewModel.getDolarBlue()

        XCTAssertEqual(result?.venta, 105)
    }

    func testGetDolarBlueFailure() async {
        currencyService.dolarBlueResult = .failure(MockError.failure)

        do {
            _ = try await viewModel.getDolarBlue()
            XCTFail("Expected to throw")
        } catch {
            // Expected error
        }
    }

    func testGetUserCountryReturnsValue() {
        locationService.country = "AR"

        let result = viewModel.getUserCountry()

        XCTAssertEqual(result, "AR")
    }

    func testGetUserCountryReturnsNil() {
        locationService.country = nil
        XCTAssertNil(viewModel.getUserCountry())
    }

    func testFetchPlacesSuccess() throws {
        let place = PlaceItem(id: 1,
                              name: "Test",
                              address: "",
                              city: "CABA",
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
        placeService.fetchResult = .success([place])

        let result = try viewModel.fetchPlaces(city: "CABA")

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Test")
    }

    func testFetchPlacesFailure() {
        placeService.fetchResult = .failure(MockError.failure)
        XCTAssertThrowsError(try viewModel.fetchPlaces(city: "CABA"))
    }

    func testFetchCitiesItems() {
        let items = [CitiesItem(name: "Buenos Aires", image: "ba"),
                     CitiesItem(name: "Cordoba", image: "cba")]
        cityDataService.items = items

        let result = viewModel.fetchCitiesItems()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.name, "Buenos Aires")
    }

    func testFetchDiscoverItems() {
        let items = [DiscoverItem(name: "Museo", image: "museo")]
        discoverDataService.items = items

        let result = viewModel.fetchDiscoverItems()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Museo")
    }
}

