//
//  UserProfileViewModel.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 14/04/2025.
//
import SwiftUI
import GoogleSignIn

//enum UserProfileState {
//    case loading
//    case loaded(AppUser)
//    case error(String)
//}

//protocol UserProfileViewModelProtocol {
//    var state: UserProfileState { get }
//    var preferredCurrency: String { get set }
//    func loadUserData()
//    func savePreferredCurrency(_ currency: String)
//    func signOut()
//    
//}

//class UserProfileViewModel: ObservableObject{
//    
//    @Published var state: UserProfileState = .loading
//    @Published var preferredCurrency: String = "ARS" // Valor por defecto
//    
//    var userService: UserServiceProtocol
//    
//    init(userService: UserServiceProtocol) {
//        self.userService = userService
//    }
    
//    func signOut() {
//        GIDSignIn.sharedInstance.signOut()
//        userService.deleteUser()
//        
//        // Volver a la pantalla de login
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let window = windowScene.windows.first {
//            let loginVC = LoginViewController()
//            window.rootViewController = loginVC
//            window.makeKeyAndVisible()
//            
//            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
//        }
//    }
//    func savePreferredCurrency(_ currency: String) {
//        preferredCurrency = currency
//        // Solo intentamos guardar en UserDefaults si hay un usuario
//        if case .loaded = state {
//            userService.savePreferredCurrency(currency)
//        }
//        // Si no hay usuario, preferredCurrency se mantiene localmente
//    }
//    
//    func loadUserData() {
//        state = .loading
//        if let user = userService.loadUser() {
//            state = .loaded(user)
//            preferredCurrency = user.preferredCurrency ?? "ARS"
//        } else {
//            state = .error("No se pudo cargar el usuario")
//        }
//    }
    
//}
import Foundation
import GoogleSignIn
import UIKit

enum UserProfileState {
    case loading
    case loaded(AppUser)
    case error(String)
}

protocol UserProfileViewModelProtocol {
    var preferredCurrency: String { get set }
    func getState() -> UserProfileState
    func loadUserData()
    func savePreferredCurrency(_ currency: String)
    func signOut()
}

class UserProfileViewModel: UserProfileViewModelProtocol {
    private var state: UserProfileState = .loading
    var preferredCurrency: String
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
        self.preferredCurrency = userService.loadPreferredCurrency() ?? CurrencyOptions.ARS.rawValue
    }
    
    func getState() -> UserProfileState {
        return state
    }
    
    func loadUserData() {
        state = .loading
        if let user = userService.loadUser() {
            state = .loaded(user)
            // Solo actualizamos preferredCurrency si el usuario tiene un valor definido
            if let userPreferredCurrency = user.preferredCurrency {
                preferredCurrency = userPreferredCurrency
                userService.savePreferredCurrency(userPreferredCurrency) // Aseguramos que se guarde en UserDefaults
            }
        } else {
            state = .error("Error al cargar el perfil: No se encontró el usuario")
        }
    }
    
    func savePreferredCurrency(_ currency: String) {
        preferredCurrency = currency
        userService.savePreferredCurrency(currency)
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        userService.deleteUser()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let loginVC = LoginViewController()
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
