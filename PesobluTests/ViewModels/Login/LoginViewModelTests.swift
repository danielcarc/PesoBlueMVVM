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
            let options = FirebaseOptions(
                googleAppID: "1:1234567890:ios:abcdef123456",
                gcmSenderID: "1234567890"
            )
            options.clientID = "test-client"
            options.apiKey = "AIzaSyA1234567890BCDEF1234567890ghijklm"
            options.projectID = "test-project"
            FirebaseApp.configure(name: "test", options: options)
        }
        let app = FirebaseApp.app(name: "test")!
        let gid = GIDSignIn.sharedInstance
        let userService = UserService()
        let sut = TestAuthVM(firebaseApp: app, gidSignIn: gid, userService: userService)
        let delegate = DelegateSpy()
        sut.delegate = delegate
        return (sut, delegate)
    }

    func testGoogleSignInSuccessUpdatesAuthenticationState() async {
        let (sut, _) = makeSUT()
        var received: [AuthenticationState] = []
        let exp = expectation(description: "Expect authenticated state")

        sut.authenticationState
            .sink { state in
                received.append(state)
                if state == .authenticated { exp.fulfill() }
            }
            .store(in: &cancellables)

        await sut.simulateGoogleSignInSuccess()

        await fulfillment(of: [exp], timeout: 1)
        XCTAssertEqual(received, [.authenticating, .authenticated])
    }

    func testGoogleSignInFailureEmitsUnauthenticatedAndReportsError() async {
        let (sut, delegate) = makeSUT()
        var received: [AuthenticationState] = []
        let exp = expectation(description: "Expect unauthenticated state")

        sut.authenticationState
            .sink { state in
                received.append(state)
                if state == .unauthenticated { exp.fulfill() }
            }
            .store(in: &cancellables)

        await sut.simulateGoogleSignInFailure()

        await fulfillment(of: [exp], timeout: 1)
        XCTAssertEqual(received, [.authenticating, .unauthenticated])
        XCTAssertTrue(delegate.error is AuthenticationViewModel.AuthError)
    }

    func testAppleSignInSuccessUpdatesAuthenticationState() async {
        let (sut, _) = makeSUT()
        var received: [AuthenticationState] = []
        let exp = expectation(description: "Expect authenticated state")

        sut.authenticationState
            .sink { state in
                received.append(state)
                if state == .authenticated { exp.fulfill() }
            }
            .store(in: &cancellables)

        await sut.simulateAppleSignInSuccess()

        await fulfillment(of: [exp], timeout: 1)
        XCTAssertEqual(received, [.authenticating, .authenticated])
    }

    func testAppleSignInFailureEmitsUnauthenticatedAndReportsError() async {
        let (sut, delegate) = makeSUT()
        var received: [AuthenticationState] = []
        let exp = expectation(description: "Expect unauthenticated state")

        sut.authenticationState
            .sink { state in
                received.append(state)
                if state == .unauthenticated { exp.fulfill() }
            }
            .store(in: &cancellables)

        await sut.simulateAppleSignInFailure()

        await fulfillment(of: [exp], timeout: 1)
        XCTAssertEqual(received, [.authenticating, .unauthenticated])
        XCTAssertTrue(delegate.error is AuthenticationViewModel.AuthError)
    }

    // MARK: - Test Doubles

    private final class TestAuthVM: AuthenticationViewModel {
        func simulateGoogleSignInSuccess() async {
            await MainActor.run {
                self.setValue(AuthenticationState.authenticating, forKey: "_authenticationState")
            }
            await MainActor.run {
                self.setValue(AuthenticationState.authenticated, forKey: "_authenticationState")
                self.onAuthenticationSuccess?()
            }
        }

        func simulateGoogleSignInFailure() async {
            await MainActor.run {
                self.setValue(AuthenticationState.authenticating, forKey: "_authenticationState")
            }
            await MainActor.run {
                self.setValue(AuthenticationState.unauthenticated, forKey: "_authenticationState")
                self.delegate?.showError(AuthenticationViewModel.AuthError.networkError)
            }
        }

        func simulateAppleSignInSuccess() async {
            await MainActor.run {
                self.setValue(AuthenticationState.authenticating, forKey: "_authenticationState")
            }
            await MainActor.run {
                self.setValue(AuthenticationState.authenticated, forKey: "_authenticationState")
                self.onAuthenticationSuccess?()
            }
        }

        func simulateAppleSignInFailure() async {
            await MainActor.run {
                self.setValue(AuthenticationState.authenticating, forKey: "_authenticationState")
            }
            await MainActor.run {
                self.setValue(AuthenticationState.unauthenticated, forKey: "_authenticationState")
                self.delegate?.showError(AuthenticationViewModel.AuthError.networkError)
            }
        }
    }

    private final class DelegateSpy: AuthenticationDelegate {
        var error: Error?
        func showError(_ error: Error) {
            self.error = error
        }
    }
}
