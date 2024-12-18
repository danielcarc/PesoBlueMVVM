//
//  DiscoverItem.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 10/12/2024.
//

import Foundation



struct DiscoverItem {
    let name: String
    let image: String
}

extension DiscoverItem {
    init(dict: [String: String]) {
        self.name = dict["name"] ?? ""
        self.image = dict["image"] ?? ""
    }
}
