//
//  AuthenticationViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 24/10/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import Combine
import AuthenticationServices
import CryptoKit

protocol AuthenticationViewModelProtocol: AnyObject {
    var onAuthenticationSuccess: (() -> Void)? { get set }
    /// Signs in the user using Google authentication.
    @MainActor
    func signInWithGoogle() async throws
    @MainActor
    func signInWithApple()
    func signOut() throws
    var delegate: AuthenticationDelegate? { get set }
    var authenticationState: AnyPublisher<AuthenticationState, Never> { get }
}

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

protocol AuthenticationDelegate: AnyObject {
    func showError(_ error: Error)
}

class AuthenticationViewModel: NSObject, AuthenticationViewModelProtocol{
    @Published private var _authenticationState: AuthenticationState = .unauthenticated
    
    weak var delegate: AuthenticationDelegate?
    var onAuthenticationSuccess: (() -> Void)?
    
    private let firebaseApp: FirebaseApp
    private let gidSignIn: GIDSignIn
    private let userService: UserService
    private var currentNonce: String?

    
    init(firebaseApp: FirebaseApp, gidSignIn: GIDSignIn, userService: UserService) {
        self.firebaseApp = firebaseApp
        self.gidSignIn = gidSignIn
        self.userService = userService
        super.init()
    }
    
    var authenticationState: AnyPublisher<AuthenticationState, Never> {
        $_authenticationState
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    enum AuthenticationError: Error{
        case tokenError(message: String)
    }
    
    enum AuthError: LocalizedError {
        case networkError
        case invalidCredentials
        case userCancelled
        case unknown

        var errorDescription: String? {
            switch self {
            case .networkError:
                return NSLocalizedString("network_error", comment: "No internet connection")
            case .invalidCredentials:
                return NSLocalizedString("invalid_credentials", comment: "Invalid credentials")
            case .userCancelled:
                return NSLocalizedString("user_cancelled", comment: "User cancelled login")
            case .unknown:
                return NSLocalizedString("unknown_auth_error", comment: "Unknown authentication error")
            }
        }
    }
    
}


    // MARK: - Google Sign In

extension AuthenticationViewModel{
    
    @MainActor
    func signInWithGoogle() async throws {
        await MainActor.run {
            _authenticationState = .authenticating
        }
        guard let clientID = firebaseApp.options.clientID else {
            throw AuthError.unknown
        }
        let config = GIDConfiguration(clientID: clientID)
        gidSignIn.configuration = config

        let rootViewController: UIViewController = try await MainActor.run {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                throw AuthError.unknown
            }
            return rootViewController
        }

        do{
            let userAuthentication = try await gidSignIn.signIn(withPresenting: rootViewController)
            let user =  userAuthentication.user
            guard let idToken = user.idToken else {
                throw AuthenticationError.tokenError(message: "Id token missing")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            let appUser = AppUser(firebaseUser: firebaseUser, preferredCurrency: nil)
            let existingUser = userService.loadUser()
            if existingUser?.uid != appUser.uid {
                userService.saveUser(appUser)
                AppLogger.debug("AppUser saved to UserDefaults")
            } else {
                AppLogger.debug("User already exists in UserDefaults")
            }
            await MainActor.run {
                _authenticationState = .authenticated
                onAuthenticationSuccess?()
            }

        } catch {
            await MainActor.run {
                _authenticationState = .unauthenticated
                delegate?.showError(error)
            }
            throw error
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        userService.deleteUser()
        _authenticationState = .unauthenticated
    }
}

    // MARK: - Apple Sign In

extension AuthenticationViewModel: ASAuthorizationControllerDelegate {

    @MainActor
    func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }

            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
        return result
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            delegate?.showError(AuthError.unknown)
            return
        }

        let credential = OAuthProvider.credential(providerID: .apple,
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)

        Task {
            do {
                let result = try await Auth.auth().signIn(with: credential)
                let firebaseUser = result.user
                let appUser = AppUser(firebaseUser: firebaseUser, preferredCurrency: nil)
                let existingUser = userService.loadUser()
                if existingUser?.uid != appUser.uid {
                    userService.saveUser(appUser)
                    AppLogger.debug("AppUser saved to UserDefaults")
                } else {
                    AppLogger.debug("User already exists in UserDefaults")
                }
                await MainActor.run {
                    _authenticationState = .authenticated
                    onAuthenticationSuccess?()
                }
            } catch {
                await MainActor.run {
                    delegate?.showError(error)
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.showError(error)
    }
}

    // MARK: - Testing

extension AuthenticationViewModel {
    /// Allows tests to manually control the authentication state without using
    /// Key-Value Coding. The assignment happens on the main actor to mirror the
    /// behavior of production code.
    @MainActor
    func setAuthenticationStateForTesting(_ state: AuthenticationState) {
        _authenticationState = state
    }
}
