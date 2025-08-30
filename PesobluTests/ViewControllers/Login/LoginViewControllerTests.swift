//
//  LoginViewControllerTests.swift
//  PesobluTests
//
//  Created by Daniel Carcacha on 29/08/2025.
//
import XCTest
import Combine
@testable import Pesoblu

final class LoginViewControllerTests: XCTestCase {
    private var sut: LoginViewController!
    private var mockAuthVM: MockAuthVM!
    private var mockCoordinator: CoordinatorSpy!
    private var userService: UserService!

    override func setUp() {
        super.setUp()
        mockAuthVM = MockAuthVM()
        mockCoordinator = CoordinatorSpy()
        userService = UserService()
        sut = LoginViewController(authVM: mockAuthVM, userService: userService, coordinator: mockCoordinator)
    }

    override func tearDown() {
        sut = nil
        mockAuthVM = nil
        mockCoordinator = nil
        userService = nil
        super.tearDown()
    }

    @MainActor
    func testGoogleButtonTapInvokesCoordinatorOnSuccess() async {
        let exp = expectation(description: "Coordinator called")
        mockCoordinator.onDidLogin = { exp.fulfill() }
        mockAuthVM.signInWithGoogleHandler = { self.mockAuthVM.onAuthenticationSuccess?() }
        sut.loadViewIfNeeded()
        guard let loginView = sut.view as? LoginView else { return XCTFail("Expected LoginView") }
        loginView.onGoogleSignInTap?()
        await fulfillment(of: [exp], timeout: 1)
        XCTAssertTrue(mockCoordinator.didLogin)
        XCTAssertTrue(mockAuthVM.signInCalled)
    }

    @MainActor
    func testAppleButtonTapInvokesAuthVM() {
        mockAuthVM.signInWithAppleHandler = { }
        sut.loadViewIfNeeded()
        guard let loginView = sut.view as? LoginView else { return XCTFail("Expected LoginView") }
        loginView.onAppleSignInTap?()
        XCTAssertTrue(mockAuthVM.signInCalled)
    }
    
    @MainActor
    func testAppleButtonTapDoesNotInvokeCoordinatorWithoutSuccess() {
        mockAuthVM.signInWithAppleHandler = { }
        sut.loadViewIfNeeded()
        guard let loginView = sut.view as? LoginView else { return XCTFail("Expected LoginView") }
        loginView.onAppleSignInTap?()
        XCTAssertFalse(mockCoordinator.didLogin)
    }

//    @MainActor
//    func testAppleButtonTapInvokesAuthVM() {
//        sut.loadViewIfNeeded()
//        guard let loginView = sut.view as? LoginView else { return XCTFail("Expected LoginView") }
//        loginView.onAppleSignInTap?()
//        XCTAssertTrue(mockAuthVM.signInAppleCalled)
//        XCTAssertFalse(mockCoordinator.didLogin)
//    }
    
    @MainActor
    func testAppleButtonTapInvokesCoordinatorOnSuccess() {
        let exp = expectation(description: "Coordinator called")
        mockCoordinator.onDidLogin = { exp.fulfill() }
        mockAuthVM.signInWithAppleHandler = { self.mockAuthVM.onAuthenticationSuccess?() }
        sut.loadViewIfNeeded()
        guard let loginView = sut.view as? LoginView else { return XCTFail("Expected LoginView") }
        loginView.onAppleSignInTap?()
        waitForExpectations(timeout: 1)
        XCTAssertTrue(mockCoordinator.didLogin)
        XCTAssertTrue(mockAuthVM.signInCalled)
    }

    // MARK: - Test Doubles

    private final class MockAuthVM: AuthenticationViewModelProtocol {
        
        var signInWithAppleHandler: (() -> Void)?

        func signInWithApple() {
            signInCalled = true
            subject.send(.authenticating)
            signInWithAppleHandler?()
            subject.send(.authenticated)
        }
        
        var onAuthenticationSuccess: (() -> Void)?
        var delegate: AuthenticationDelegate?
        private let subject = PassthroughSubject<AuthenticationState, Never>()
        var signInCalled = false
        var signInWithGoogleHandler: (() -> Void)?
        var authenticationState: AnyPublisher<AuthenticationState, Never> {
            subject.eraseToAnyPublisher()
        }
        
        @MainActor
        func signInWithGoogle() async throws {
            signInCalled = true
            subject.send(.authenticating)
            signInWithGoogleHandler?()
            subject.send(.authenticated)
        }
        
        func signOut() throws {}
    }
    
    private final class CoordinatorSpy: LoginNavigationDelegate {
        var didLogin = false
        var onDidLogin: (() -> Void)?
        func didLoginSuccessfully() {
            didLogin = true
            onDidLogin?()
        }
    }
}
