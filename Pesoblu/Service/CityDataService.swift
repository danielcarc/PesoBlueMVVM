//
//  CitysDataManager.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 12/01/2025.
//

import Foundation

protocol CityDataServiceProtocol{
    func fetch() -> [CitiesItem]
}

class CityDataService: DataManager, CityDataServiceProtocol{
    
    private var cityItems: [CitiesItem] = []
    
    func fetch() -> [CitiesItem] {
        cityItems = []
        switch loadPlist(file: "CitysAr") {
        case .success(let dataArray):
            for data in dataArray {
                cityItems.append(CitiesItem(dict: data as! [String: String]))
            }
        case .failure(let error):
            AppLogger.error("Error loading CitysAr: \(error)")
        }
        return cityItems
    }
    
    func numberOfExploreItems() -> Int {
        cityItems.count
    }
    
    func exploreItem(at index: Int) -> CitiesItem {
        cityItems[index]
    }
    
}
