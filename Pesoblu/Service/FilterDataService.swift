//
//  FilterDataManager.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 20/01/2025.
//

import Foundation

protocol FilterDataServiceProtocol{
    func fetch() -> [DiscoverItem]
}
class FilterDataService: DataManager, FilterDataServiceProtocol{
    
    private var discoverItems: [DiscoverItem] = []
    //private var placeItems: [PlaceItem] = []
    
    func fetch() -> [DiscoverItem] {
        discoverItems.removeAll()
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
    
}
