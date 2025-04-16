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
}

final class UserService: UserServiceProtocol {
    
    private let userDefaultsKey = "currentUser"
    
    // Guardar usuario en UserDefaults
    func saveUser(_ user: AppUser) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
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
            print("Failed to load user: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Eliminar usuario de UserDefaults (por ejemplo, en logout)
    func deleteUser() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
