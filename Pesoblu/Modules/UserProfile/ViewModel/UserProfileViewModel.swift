//
//  UserProfileViewModel.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 14/04/2025.
//
import SwiftUI
import GoogleSignIn

enum UserProfileState {
    case loading
    case loaded(AppUser)
    case error(String)
}

protocol UserProfileViewModelProtocol {
    var preferredCurrency: String { get set }
    var didSignOut: Bool { get }
    var state: UserProfileState { get }
    func loadUserData()
    func savePreferredCurrency(_ currency: String)
    @MainActor func signOut()
}

protocol UserProfileViewModelDelegate: AnyObject{
    func didSignOut()
}

class UserProfileViewModel: UserProfileViewModelProtocol, ObservableObject {
    @Published private(set) var state: UserProfileState = .loading
    @Published var showSignOutAlert = false
    var preferredCurrency: String
    weak var delegate: UserProfileViewModelDelegate?
    @Published var didSignOut: Bool = false
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
        self.preferredCurrency = userService.loadPreferredCurrency() ?? CurrencyOptions.ARS.rawValue
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
        if case .loaded(var user) = state {
            user.preferredCurrency = currency
            state = .loaded(user)
        }
    }
    
    @MainActor
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        userService.deleteUser()
        didSignOut = true
        state = .loading
    }
}


