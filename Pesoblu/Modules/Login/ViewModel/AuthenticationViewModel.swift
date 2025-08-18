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

protocol AuthenticationViewModelProtocol: AnyObject {
    var onAuthenticationSuccess: (() -> Void)? { get set }
    func singInWithGoogle() async throws
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

class AuthenticationViewModel: AuthenticationViewModelProtocol{
    @Published private var _authenticationState: AuthenticationState = .unauthenticated
    
    weak var delegate: AuthenticationDelegate?
    var onAuthenticationSuccess: (() -> Void)?
    
    private let firebaseApp: FirebaseApp
    private let gidSignIn: GIDSignIn
    private let userService: UserService
    
    init(firebaseApp: FirebaseApp, gidSignIn: GIDSignIn, userService: UserService) {
        self.firebaseApp = firebaseApp
        self.gidSignIn = gidSignIn
        self.userService = userService
    }
    
    var authenticationState: AnyPublisher<AuthenticationState, Never> {
        $_authenticationState
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    enum AuthenticationError: Error{
        case tokenError(message: String)
    }
    
    enum AuthError: Error {
        case networkError
        case invalidCredentials
        case userCancelled
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .networkError:
                return "No hay conexión a Internet."
            case .invalidCredentials:
                return "Las credenciales son inválidas."
            case .userCancelled:
                return "El usuario canceló el inicio de sesión."
            case .unknown:
                return "Ocurrió un error desconocido."
            }
        }
    }
    
}


//MARK: - Google Sign In

extension AuthenticationViewModel{
    
    func singInWithGoogle() async throws {
        await MainActor.run {
            _authenticationState = .authenticating
        }
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No Client ID found in Firebase Configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        let rootViewController: UIViewController = try await MainActor.run {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                throw AuthError.unknown
            }
            return rootViewController
        }

        do {
            let userAuthentication = try await MainActor.run {
                try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            }
            let user = userAuthentication.user
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

