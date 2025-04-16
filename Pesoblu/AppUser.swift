//
//  AppUser.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 11/11/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Kingfisher

struct AppUser: Codable{
    
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
    let preferredCurrency: String?
    let providerID: String?
    
    init(firebaseUser: User, preferredCurrency: String?) {
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email
        self.displayName = firebaseUser.displayName
        self.photoURL = firebaseUser.photoURL
        self.providerID = firebaseUser.providerID
        self.preferredCurrency = preferredCurrency
    }
}
