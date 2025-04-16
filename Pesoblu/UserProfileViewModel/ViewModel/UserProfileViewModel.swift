//
//  UserProfileViewModel.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 14/04/2025.
//
import SwiftUI

protocol UserProfileViewModelProtocol {
    func loadUser() -> AppUser?
    
}

class UserProfileViewModel: ObservableObject{
    
    @Published var user: AppUser? = nil
    
    var userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    
}
extension UserProfileViewModel: UserProfileViewModelProtocol{
    
    func loadUser() -> AppUser?{
        user = userService.loadUser()
        return user
    }
    
    func saveUser(_ user: AppUser){
        userService.saveUser(user)
    }
}
