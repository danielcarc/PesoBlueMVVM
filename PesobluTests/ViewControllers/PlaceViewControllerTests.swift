//
//  PlaceViewControllerTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 03/08/2025.
//

import XCTest
import UIKit
@testable import Pesoblu

final class PlaceViewControllerTests: XCTestCase {

    final class MockPlaceViewModel: PlaceViewModelProtocol {
        var didCallSaveFavorite = false
        var favoriteResult: Bool = false
        var shouldThrow = false

        var onSaveFavoriteCalled: (() -> Void)?

        func saveFavoriteStatus(isFavorite: Bool) async throws {
            if shouldThrow { throw NSError(domain: "TestError", code: 1) }
            didCallSaveFavorite = true
            onSaveFavoriteCalled?()
        }

        func loadFavoriteStatus() async throws -> Bool {
            if shouldThrow { throw NSError(domain: "TestError", code: 1) }
            return favoriteResult   // <- sin DispatchQueue ni capturas
        }
    }


    final class MockAlertPresenter: AlertPresenter {
        var didShowAlert = false
        var alertTitle: String?
        var alertMessage: String?
        var onAlertShown: (() -> Void)?

        func present(on viewController: UIViewController, title: String, message: String) {
            didShowAlert = true
            alertTitle = title
            alertMessage = message
            onAlertShown?()
        }
    }

    private var sut: PlaceViewController!
    private var mockViewModel: MockPlaceViewModel!
    private var mockAlertPresenter: MockAlertPresenter!

    override func setUp() {
        super.setUp()
        mockViewModel = MockPlaceViewModel()
        mockAlertPresenter = MockAlertPresenter()
        sut = PlaceViewController(placeViewModel: mockViewModel,
                                  place: PlaceItem(
                                        id: 1,
                                        name: "Test Place",
                                        address: "Calle Falsa 123",
                                        city: "Buenos AIRES",
                                        state: "Palermo",
                                        area: "Palermo",
                                        postalCode: "1111",
                                        country: "Argentina",
                                        phone: "https://www.instagram.com/test/",
                                        lat: -34.6037,
                                        long: -58.3816,
                                        price: "$",
                                        categories: ["Bar"],
                                        cuisines: ["Comida"],
                                        instagram: "https://www.instagram.com/test/",
                                        imageUrl: "",
                                        placeType: .resto,
                                        placeDescription: ""),
                                  alertPresenter: mockAlertPresenter)
        //_ = sut.view  // Trigger view load
    }

    override func tearDown() {
        sut = nil
        mockViewModel = nil
        mockAlertPresenter = nil
        super.tearDown()
    }
    
    func test_toggleFavorite_callsSaveFavoriteStatus() {
        // Given
        mockViewModel.favoriteResult = false
        let expectation = expectation(description: "Esperando que se llame saveFavoriteStatus")
        
        mockViewModel.onSaveFavoriteCalled = {
            DispatchQueue.main.async {
                expectation.fulfill()
            }
            
        }
        _ = sut.view
        // When
        sut.toggleFavorite()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockViewModel.didCallSaveFavorite, "Debe llamar al método saveFavoriteStatus al hacer toggle.")
    }
    
    func test_loadFavoriteStatus_setsIsFavoriteTrue() {
        mockViewModel.favoriteResult = true
        _ = sut.view
        let exp = expectation(description: "isFavorite actualizado a true")

        sut.onFavoriteUpdated = { isFav in
            if isFav { exp.fulfill() }
        }

        sut.loadFavoriteStatus()

        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(sut.test_isFavorite)
    }
    
    func test_loadFavoriteStatus_whenFails_showsAlert() {
        // Given
        mockViewModel.shouldThrow = true
        let expectation = expectation(description: "Esperando que se llame showAlert")
        
        mockAlertPresenter.onAlertShown = {
            expectation.fulfill()
        }
        
        // When
        sut.loadFavoriteStatus()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockAlertPresenter.didShowAlert)
        XCTAssertEqual(mockAlertPresenter.alertTitle, "Error")
    }
}
