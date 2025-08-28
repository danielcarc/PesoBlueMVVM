//
//  UserProfileViewModelTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 19/08/2025.
//

import XCTest
import Foundation
import GoogleSignIn
@testable import Pesoblu

final class UserProfileViewModelTests: XCTestCase {
    private var viewModel: UserProfileViewModel!
    private var mockService: MockUserService!

    override func setUp() {
        super.setUp()
        mockService = MockUserService()
        viewModel = UserProfileViewModel(gidSignIn: GIDSignIn.sharedInstance, userService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testLoadUserDataUpdatesState() {
        let user = AppUser(uid: "123",
                           email: "test@example.com",
                           displayName: "Tester",
                           photoURL: nil,
                           preferredCurrency: "USD",
                           providerID: "google")
        mockService.storedUser = user

        viewModel.loadUserData()

        if case .loaded(let loadedUser) = viewModel.state {
            XCTAssertEqual(loadedUser.uid, user.uid)
            XCTAssertEqual(viewModel.preferredCurrency, "USD")
            XCTAssertEqual(mockService.storedPreferredCurrency, "USD")
        } else {
            XCTFail("Expected state to be .loaded")
        }
    }

    func testSavePreferredCurrencyPersistsCurrency() {
        let user = AppUser(uid: "123",
                           email: nil,
                           displayName: nil,
                           photoURL: nil,
                           preferredCurrency: "USD",
                           providerID: nil)
        mockService.storedUser = user
        viewModel.loadUserData()

        viewModel.savePreferredCurrency("EUR")

        XCTAssertEqual(viewModel.preferredCurrency, "EUR")
        XCTAssertEqual(mockService.storedPreferredCurrency, "EUR")
        if case .loaded(let loadedUser) = viewModel.state {
            XCTAssertEqual(loadedUser.preferredCurrency, "EUR")
        } else {
            XCTFail("Expected state to be .loaded")
        }
    }

    @MainActor func testSignOutMarksDidSignOutAndClearsData() {
        let user = AppUser(uid: "123",
                           email: nil,
                           displayName: nil,
                           photoURL: nil,
                           preferredCurrency: "USD",
                           providerID: nil)
        mockService.storedUser = user
        viewModel.loadUserData()

        viewModel.signOut()

        XCTAssertTrue(viewModel.didSignOut)
        if case .loading = viewModel.state {
            // success
        } else {
            XCTFail("State should be .loading after signOut")
        }
        XCTAssertTrue(mockService.deleteUserCalled)
        XCTAssertNil(mockService.storedUser)
        XCTAssertNil(mockService.storedPreferredCurrency)
    }
}

private final class MockUserService: UserServiceProtocol {
    var storedUser: AppUser?
    var storedPreferredCurrency: String?
    var deleteUserCalled = false

    func saveUser(_ user: AppUser) {
        storedUser = user
    }

    func loadUser() -> AppUser? {
        return storedUser
    }

    func savePreferredCurrency(_ currency: String) {
        storedPreferredCurrency = currency
    }

    func loadPreferredCurrency() -> String? {
        return storedPreferredCurrency
    }

    func deleteUser() {
        deleteUserCalled = true
        storedUser = nil
        storedPreferredCurrency = nil
    }
}

