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
        switch loadPlist(file: "PlacesBa") {
        case .success(let dataArray):
            for data in dataArray {
                discoverItems.append(DiscoverItem(dict: data as! [String: String]))
            }
        case .failure(let error):
            print("Error loading PlacesBa: \(error)")
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


