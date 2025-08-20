//
//  UserProfileViewTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 19/08/2025.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import Pesoblu


final class UserProfileViewTests: XCTestCase {

    func testLoadingStateShowsLoadingText() throws {
        let service = MockUserService()
        let viewModel = LoadingMockUserProfileViewModel(userService: service)
        let sut = UserProfileView(viewModel: viewModel, onSignOut: {})

        try sut.inspect().callOnAppear()

        XCTAssertNoThrow(try sut.inspect().find(text: NSLocalizedString("profile_loading", comment: "")))
    }

    func testErrorStateShowsErrorMessage() throws {
        let service = MockUserService()
        let viewModel = UserProfileViewModel(userService: service)
        let sut = UserProfileView(viewModel: viewModel, onSignOut: {})

        try sut.inspect().callOnAppear()

        XCTAssertNoThrow(try sut.inspect().find(text: "Error al cargar el perfil: No se encontró el usuario"))
    }

    func testLoadedStateShowsUserInfo() throws {
        let user = AppUser(uid: "123",
                           email: "test@example.com",
                           displayName: "Tester",
                           photoURL: nil,
                           preferredCurrency: "USD",
                           providerID: nil)
        let service = MockUserService()
        service.storedUser = user
        let viewModel = UserProfileViewModel(userService: service)
        let sut = UserProfileView(viewModel: viewModel, onSignOut: {})

        try sut.inspect().callOnAppear()

        XCTAssertNoThrow(try sut.inspect().find(text: "Tester"))
        XCTAssertNoThrow(try sut.inspect().find(text: "test@example.com"))
    }

    func testSignOutConfirmationTriggersCallbackAndShowsToast() throws {
        let user = AppUser(uid: "123",
                           email: "test@example.com",
                           displayName: "Tester",
                           photoURL: nil,
                           preferredCurrency: "USD",
                           providerID: nil)
        let service = MockUserService()
        service.storedUser = user
        let viewModel = SignOutMockUserProfileViewModel(userService: service)
        let expectation = expectation(description: "onSignOut called")
        let sut = UserProfileView(viewModel: viewModel, onSignOut: {
            expectation.fulfill()
        })

        ViewHosting.host(view: sut)
        defer { ViewHosting.expel() }
        
        XCTAssertNoThrow(try sut.inspect().callOnAppear())
        
        let button = try? sut.inspect().find(ViewType.Button.self, where: { try $0.labelView().text().string() == NSLocalizedString("sign_out_button", comment: "") })
        XCTAssertNotNil(button)
        XCTAssertNoThrow(try button?.tap())
        XCTAssertNoThrow(try sut.inspect().alert().button(0).tap())

        XCTAssertNoThrow(try sut.inspect().find(text: NSLocalizedString("sign_out_success", comment: "")))

        wait(for: [expectation], timeout: 3)
    }
}

private final class LoadingMockUserProfileViewModel: UserProfileViewModel {
    override func loadUserData() {
        // Keep state as .loading
    }
}

private final class SignOutMockUserProfileViewModel: UserProfileViewModel {
    override func signOut() {
        didSignOut = true
    }
}

private final class MockUserService: UserServiceProtocol {
    var storedUser: AppUser?
    var storedPreferredCurrency: String?

    func saveUser(_ user: AppUser) {
        storedUser = user
    }

    func loadUser() -> AppUser? {
        storedUser
    }

    func savePreferredCurrency(_ currency: String) {
        storedPreferredCurrency = currency
    }

    func loadPreferredCurrency() -> String? {
        storedPreferredCurrency
    }

    func deleteUser() {
        storedUser = nil
        storedPreferredCurrency = nil
    }
}
