//
//  DiscoverDataManager.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 10/12/2024.
//

import Foundation

protocol DiscoverDataServiceProtocol {
    func fetch() -> [DiscoverItem]
}

class DiscoverDataService: DataManager, DiscoverDataServiceProtocol{
    
    private var discoverItems: [DiscoverItem] = []
    //private var placeItems: [PlaceItem] = []
    
    func fetch() -> [DiscoverItem] {
        discoverItems = []
        for data in loadPlist(file: "PlacesBa") {
            discoverItems.append(DiscoverItem(dict: data as! [String: String]))
        }
        return discoverItems
    }
    
    func numberOfExploreItems() -> Int {
        discoverItems.count
    }
    
    func exploreItem(at index: Int) -> DiscoverItem {
        discoverItems[index]
    }
    
}


