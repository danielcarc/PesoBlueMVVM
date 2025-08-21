//
//  UserProfileViewTests.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 19/08/2025.
//

import XCTest
import SwiftUI
import Foundation
import ViewInspector
@testable import Pesoblu

final class UserProfileViewTests: XCTestCase {

    // MARK: Loading
    func testLoadingStateShowsLoadingText() throws {
        // VM que deja el estado en .loading
        let service = MockUserService()
        let vm = LoadingMockUserProfileViewModel(userService: service)
        let sut = UserProfileView(viewModel: vm, onSignOut: {})

        ViewHosting.host(view: sut)
        defer { ViewHosting.expel() }

        pumpRunLoop(0.05) // deja que SwiftUI pinte

        XCTAssertNoThrow(
            try sut.inspect().find(text: NSLocalizedString("profile_loading", comment: ""))
        )
    }

    // MARK: Error
    func testErrorStateShowsErrorMessage() throws {
        // Sin usuario => loadUserData pone .error(...)
        let service = MockUserService()
        let vm = UserProfileViewModel(userService: service)
        let sut = UserProfileView(viewModel: vm, onSignOut: {})

        ViewHosting.host(view: sut)
        defer { ViewHosting.expel() }

        // Disparo explícitamente el flujo que en prod corre en onAppear
        vm.loadUserData()
        pumpRunLoop(0.05)

        XCTAssertNoThrow(
            try sut.inspect().find(text: "Error al cargar el perfil: No se encontró el usuario")
        )
    }

    // MARK: Loaded
    func testLoadedStateShowsUserInfo() throws {
        let user = AppUser(uid: "123",
                           email: "test@example.com",
                           displayName: "Tester",
                           photoURL: nil,
                           preferredCurrency: "USD",
                           providerID: nil)
        let service = MockUserService()
        service.storedUser = user

        let vm = UserProfileViewModel(userService: service)
        let sut = UserProfileView(viewModel: vm, onSignOut: {})

        ViewHosting.host(view: sut)
        defer { ViewHosting.expel() }

        vm.loadUserData()
        pumpRunLoop(0.05)

        XCTAssertNoThrow(try sut.inspect().find(text: "Tester"))
        XCTAssertNoThrow(try sut.inspect().find(text: "test@example.com"))
    }

    // MARK: SignOut + Toast + Callback
    @MainActor
    func testSignOutShowsToastOnceAndInvokesCallbackAfterDelay() throws {
        let user = AppUser(uid: "123",
                           email: "test@example.com",
                           displayName: "Tester",
                           photoURL: nil,
                           preferredCurrency: "USD",
                           providerID: nil)
        let service = MockUserService()
        service.storedUser = user
        let viewModel = SignOutMockUserProfileViewModel(userService: service)
        let expectation = expectation(description: "onSignOut called after delay")
        let startTime = Date()
        let sut = UserProfileView(viewModel: viewModel, onSignOut: {
            let elapsed = Date().timeIntervalSince(startTime)
            XCTAssertGreaterThanOrEqual(elapsed, 2.0)
            expectation.fulfill()
        })
        
        ViewHosting.host(view: sut)
        defer { ViewHosting.expel() }
        
        XCTAssertNoThrow(try sut.inspect().find(ViewType.ScrollView.self).callOnAppear())

        let button = try? sut.inspect().find(ViewType.Button.self, where: { try $0.labelView().text().string() == NSLocalizedString("sign_out_button", comment: "") })
        XCTAssertNotNil(button)
        XCTAssertNoThrow(try button?.tap())
        let alert = try sut.inspect().find(ViewType.Alert.self)
        try alert.primaryButton().tap()
        
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))
        
        let successCount = try sut.inspect().findAll(ViewType.Text.self, where: {
            try $0.string() == NSLocalizedString("sign_out_success", comment: "")
        }).count
        XCTAssertEqual(successCount, 1)
        
        wait(for: [expectation], timeout: 3)
    }


    // MARK: Helper
    @discardableResult
    private func pumpRunLoop(_ seconds: TimeInterval = 0.05) -> Bool {
        RunLoop.current.run(until: Date().addingTimeInterval(seconds))
        return true
    }
}

// MARK: - Mocks

/// Deja el estado en .loading (no llama loadUserData real)
private final class LoadingMockUserProfileViewModel: UserProfileViewModel {
    override func loadUserData() { /* no-op */ }
}

/// Simula signOut sin dependencias, sólo publica didSignOut = true
private final class SignOutMockUserProfileViewModel: UserProfileViewModel {
    override func signOut() { didSignOut = true }
}

private final class MockUserService: UserServiceProtocol {
    var storedUser: AppUser?
    var storedPreferredCurrency: String?

    func saveUser(_ user: AppUser) { storedUser = user }
    func loadUser() -> AppUser? { storedUser }
    func savePreferredCurrency(_ currency: String) { storedPreferredCurrency = currency }
    func loadPreferredCurrency() -> String? { storedPreferredCurrency }
    func deleteUser() { storedUser = nil; storedPreferredCurrency = nil }
}
