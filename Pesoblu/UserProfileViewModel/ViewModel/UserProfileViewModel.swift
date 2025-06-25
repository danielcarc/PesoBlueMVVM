//
//  UserProfileViewModel.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 14/04/2025.
//
import SwiftUI
import GoogleSignIn
import Foundation
import GoogleSignIn
import UIKit
import Firebase

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
    private weak var coordinator: NavigationCoordinator?
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol, coordinator: NavigationCoordinator? = nil) {
        self.userService = userService
        self.coordinator = coordinator
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
        coordinator?.showLoginScreen()
    }
}
