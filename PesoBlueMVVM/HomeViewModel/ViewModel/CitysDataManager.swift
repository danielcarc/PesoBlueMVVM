//
//  CitysDataManager.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/01/2025.
//

import Foundation


class CitysDataManager: DataManager{
    
    private var cityItems: [CitysItem] = []
    //private var placeItems: [PlaceItem] = []
    
    func fetch() -> [CitysItem] {
        for data in loadPlist(file: "CitysAr") {
            cityItems.append(CitysItem(dict: data as! [String: String]))
        }
        return cityItems
    }
    
    func numberOfExploreItems() -> Int {
        cityItems.count
    }
    
    func exploreItem(at index: Int) -> CitysItem {
        cityItems[index]
    }
    
}
