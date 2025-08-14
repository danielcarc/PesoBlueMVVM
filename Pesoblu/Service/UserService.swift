//
//  UserDefaults.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 11/11/2024.
//

import Foundation

import FirebaseAuth

protocol UserServiceProtocol{
    func saveUser(_ user: AppUser)
    func loadUser() -> AppUser?
    func savePreferredCurrency(_ currency: String)
    func loadPreferredCurrency() -> String?
    func deleteUser()
}

final class UserService: UserServiceProtocol {
    
    private let userDefaultsKey = "currentUser"
    private let preferredCurrencyKey = "preferredCurrency"
    
    // Guardar usuario en UserDefaults
    func saveUser(_ user: AppUser) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            AppLogger.error("Failed to save user: \(error.localizedDescription)")
        }
    }
    
    // Cargar usuario desde UserDefaults
    func loadUser() -> AppUser? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return nil }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(AppUser.self, from: data)
            return user
        } catch {
            AppLogger.error("Failed to load user: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Guardar solo la moneda preferida actualizando el usuario existente
    func savePreferredCurrency(_ currency: String) {
        UserDefaults.standard.set(currency, forKey: preferredCurrencyKey)
        
        // Actualizamos el usuario almacenado si existe
        if var currentUser = loadUser() {
            currentUser.preferredCurrency = currency
            saveUser(currentUser)
        }
        
    }
    
    func loadPreferredCurrency() -> String? {
        return UserDefaults.standard.string(forKey: preferredCurrencyKey)
    }
    
    // Eliminar usuario de UserDefaults (por ejemplo, en logout)
    func deleteUser() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.removeObject(forKey: preferredCurrencyKey)
    }
}
