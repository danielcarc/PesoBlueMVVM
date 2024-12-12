//
//  DiscoverDataManager.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 10/12/2024.
//

import Foundation


class DiscoverDataManager: DataManager{
    
    private var discoverItems: [DiscoverItem] = []
    
    func fetch() {
        for data in loadPlist(file: "PlacesBa") {
            discoverItems.append(DiscoverItem(dict: data as! [String: String]))
        }
    }
    
    func numberOfExploreItems() -> Int {
        discoverItems.count
    }
    
    func exploreItem(at index: Int) -> DiscoverItem {
        discoverItems[index]
    }
    
    
}
