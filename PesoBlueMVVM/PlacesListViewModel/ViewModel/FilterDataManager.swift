//
//  FilterDataManager.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 20/01/2025.
//

import Foundation

class FilterDataManager: DataManager{
    
    private var discoverItems: [DiscoverItem] = []
    //private var placeItems: [PlaceItem] = []
    
    func fetch() -> [DiscoverItem] {
        for data in loadPlist(file: "PlacesBa") {
            discoverItems.append(DiscoverItem(dict: data as! [String: String]))
        }
        return discoverItems
    }
    
    func numberOfExploreItems() -> Int {
        discoverItems.count
    }
    
}
