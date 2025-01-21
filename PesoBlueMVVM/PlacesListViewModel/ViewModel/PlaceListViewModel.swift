//
//  PlaceListViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 20/01/2025.
//
import Foundation

class PlaceListViewModel{
    
    private var discoverItem: [DiscoverItem] = []
    private var filterManager = FilterDataManager()
    
    func fetchFilterItems() -> [DiscoverItem] {
        discoverItem = filterManager.fetch()
        return discoverItem
    }
}
