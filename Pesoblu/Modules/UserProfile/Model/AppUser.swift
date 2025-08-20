//
//  AppUser.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 11/11/2024.
//

import Foundation
import FirebaseAuth

struct AppUser: Codable {
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
    var preferredCurrency: String?
    let providerID: String?

    init(uid: String,
         email: String? = nil,
         displayName: String? = nil,
         photoURL: URL? = nil,
         preferredCurrency: String? = nil,
         providerID: String? = nil) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.preferredCurrency = preferredCurrency
        self.providerID = providerID
    }

    // Existing initializer
    init(firebaseUser: User, preferredCurrency: String?){
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email
        self.displayName = firebaseUser.displayName
        self.photoURL = firebaseUser.photoURL
        self.providerID = firebaseUser.providerID
        self.preferredCurrency = preferredCurrency
    }
}
