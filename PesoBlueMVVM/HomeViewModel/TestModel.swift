//
//  TestModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 24/11/2024.
//


import Foundation
import UIKit


struct UsersResponse: Codable {
    let data: [TestData]
}

struct TestData : Codable{
    let image: String
    let title: String
    
}
