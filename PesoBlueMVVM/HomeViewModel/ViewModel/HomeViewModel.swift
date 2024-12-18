//
//  HomeViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 10/12/2024.
//

import Foundation


class HomeViewModel{
    
    private var discoverItems: [DiscoverItem] = []
    
    var manager = DiscoverDataManager()
    
    func fetch(){
        discoverItems = manager.fetch()
    }
}
