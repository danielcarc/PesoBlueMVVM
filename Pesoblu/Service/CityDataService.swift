//
//  CitysDataManager.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/01/2025.
//

import Foundation

protocol CityDataServiceProtocol{
    func fetch() -> [CitysItem]
}

class CityDataService: DataManager, CityDataServiceProtocol{
    
    private var cityItems: [CitysItem] = []
    
    func fetch() -> [CitysItem] {
        cityItems = []
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
