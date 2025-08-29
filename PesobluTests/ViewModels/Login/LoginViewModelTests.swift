//
//  LoginViewModelTests.swift
//  PesobluTests
//
//  Created by Daniel Carcacha on 29/08/2025.
//

import XCTest
import Combine
import FirebaseCore
import GoogleSignIn
@testable import Pesoblu

final class AuthenticationViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    private func makeSUT() -> (sut: TestAuthVM, delegate: DelegateSpy) {
        if FirebaseApp.app(name: "test") == nil {
            let options = FirebaseOptions(googleAppID: "1:2:3:ios:4", gcmSenderID: "1")
            options.clientID = "test-client"
            FirebaseApp.configure(name: "test", options: options)
        }
        let app = FirebaseApp.app(name: "test")!
        let gid = GIDSignIn()
        let userService = UserService()
        let sut = TestAuthVM(firebaseApp: app, gidSignIn: gid, userService: userService)
        let delegate = DelegateSpy()
        sut.delegate = delegate
        return (sut, delegate)
    }

    func testSignInSuccessUpdatesAuthenticationState() async {
        let (sut, _) = makeSUT()
        var received: [AuthenticationState] = []
        let exp = expectation(description: "Expect authenticated state")

        sut.authenticationState
            .sink { state in
                received.append(state)
                if state == .authenticated { exp.fulfill() }
            }
            .store(in: &cancellables)

        await sut.simulateSignInSuccess()

        await waitForExpectations(timeout: 1)
        XCTAssertEqual(received, [.authenticating, .authenticated])
    }

    func testSignInFailureEmitsUnauthenticatedAndReportsError() async {
        let (sut, delegate) = makeSUT()
        var received: [AuthenticationState] = []
        let exp = expectation(description: "Expect unauthenticated state")

        sut.authenticationState
            .sink { state in
                received.append(state)
                if state == .unauthenticated { exp.fulfill() }
            }
            .store(in: &cancellables)

        await sut.simulateSignInFailure()

        await waitForExpectations(timeout: 1)
        XCTAssertEqual(received, [.authenticating, .unauthenticated])
        XCTAssertTrue(delegate.error is AuthenticationViewModel.AuthError)
    }

    // MARK: - Test Doubles

    private final class TestAuthVM: AuthenticationViewModel {
        func simulateSignInSuccess() async {
            await MainActor.run {
                self.setValue(AuthenticationState.authenticating, forKey: "_authenticationState")
            }
            await MainActor.run {
                self.setValue(AuthenticationState.authenticated, forKey: "_authenticationState")
                self.onAuthenticationSuccess?()
            }
        }

        func simulateSignInFailure() async {
            await MainActor.run {
                self.setValue(AuthenticationState.authenticating, forKey: "_authenticationState")
            }
            await MainActor.run {
                self.setValue(AuthenticationState.unauthenticated, forKey: "_authenticationState")
                self.delegate?.showError(AuthenticationViewModel.AuthError.networkError)
            }
        }

        override func signInWithGoogle() async throws {
            // Not used in these tests
        }
    }

    private final class DelegateSpy: AuthenticationDelegate {
        var error: Error?
        func showError(_ error: Error) {
            self.error = error
        }
    }
}
