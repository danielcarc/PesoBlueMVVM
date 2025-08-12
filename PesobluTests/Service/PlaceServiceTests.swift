//
//  PlaceServiceTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 08/08/2025.
//

import XCTest
@testable import Pesoblu

final class PlaceServiceTests: XCTestCase {

    private var sut: PlaceService! // System Under Test
    private var testBundle: Bundle!

    override func setUp() {
        super.setUp()
        // Bundle del target de tests, donde viven los fixtures
        testBundle = Bundle(for: Self.self)
        sut = PlaceService(bundle: testBundle)
    }

    override func tearDown() {
        sut = nil
        testBundle = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_fetchPlaces_whenFileExistsAndJSONIsValid_returnsPlaces() throws {
        // Given
        let city = "ValidCity"

        // When
        let places = try sut.fetchPlaces(city: city)

        // Then
        XCTAssertFalse(places.isEmpty, "Debe devolver al menos 1 lugar")
        // Podés validar campos concretos si querés
        XCTAssertEqual(places.first?.name, "Al Fondo")
    }

    func test_fetchPlaces_whenFileDoesNotExist_throwsFileNotFound() {
        // Given
        let city = "CityThatDoesNotExist"

        // When / Then
        do {
            _ = try sut.fetchPlaces(city: city)
            XCTFail("Debería lanzar error .fileNotFound")
        } catch let error as PlaceError {
            XCTAssertEqual(error, .fileNotFound)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }

    func test_fetchPlaces_whenJSONIsInvalid_throwsFailedToParseData() {
        // Given
        let city = "InvalidCity"

        // When / Then
        do {
            _ = try sut.fetchPlaces(city: city)
            XCTFail("Debería lanzar error .failedToParseData")
        } catch let error as PlaceError {
            XCTAssertEqual(error, .failedToParseData)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }

    func test_fetchPlaces_whenJSONIsEmptyArray_throwsNoPlacesAvailable() {
        // Given
        let city = "EmptyCity"

        // When / Then
        do {
            _ = try sut.fetchPlaces(city: city)
            XCTFail("Debería lanzar error .noPlacesAvailable")
        } catch let error as PlaceError {
            XCTAssertEqual(error, .noPlacesAvailable)
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }
}
