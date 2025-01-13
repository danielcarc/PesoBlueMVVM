//
//  CitysItem.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/01/2025.
//

struct CitysItem {
    let name: String
    let image: String
}

extension CitysItem {
    init(dict: [String: String]) {
        self.name = dict["name"] ?? ""
        self.image = dict["image"] ?? ""
    }
}
