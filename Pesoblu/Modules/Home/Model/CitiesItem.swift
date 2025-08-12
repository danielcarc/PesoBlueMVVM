//
//  CitiesItem.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/01/2025.
//

import Foundation

struct CitiesItem {
    let name: String
    let image: String
}

extension CitiesItem {
    init(dict: [String: String]) {
        self.name = dict["name"] ?? ""
        self.image = dict["image"] ?? ""
    }
}
