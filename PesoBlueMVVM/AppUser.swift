//
//  AppUser.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 11/11/2024.
//

import Foundation
import FirebaseAuth

struct AppUser: Codable{
    
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
    
    init(firebaseUser: User) {
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email
        self.displayName = firebaseUser.displayName
        self.photoURL = firebaseUser.photoURL
    }
    
}
