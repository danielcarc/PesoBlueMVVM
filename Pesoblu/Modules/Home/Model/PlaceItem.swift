//
//  RestaurantItem.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 06/12/2024.
//


import UIKit
import MapKit



class PlaceItem: NSObject, Decodable, MKAnnotation{
    
    let id: Int
    let name: String
    let address: String
    let city: String
    let state: String
    let area: String
    let postalCode: String
    let country: String
    let phone: String?
    let lat: Double?
    let long: Double?
    let price: String?
    let categories: [String]?
    let cuisines: [String]?
    let instagram: String
    let imageUrl: String
    let placeType: String
    let placeDescription: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case city
        case state
        case area
        case lat
        case long
        case postalCode = "postal_code"
        case country
        case phone
        case price
        case categories
        case cuisines
        case instagram
        case imageUrl = "image_url"
        case placeType
        case placeDescription
    }
    
    init(id: Int, name: String, address: String, city: String, state: String, area: String, postalCode: String, country: String, phone: String?, lat: Double, long: Double, price: String?, categories: [String]?, cuisines: [String]?, instagram: String, imageUrl: String, placeType: String, placeDescription: String) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.area = area
        self.postalCode = postalCode
        self.country = country
        self.phone = phone
        self.lat = lat
        self.long = long
        self.price = price
        self.categories = categories
        self.cuisines = cuisines
        self.instagram = instagram
        self.imageUrl = imageUrl
        self.placeType = placeType
        self.placeDescription = placeDescription
    }
    
    var coordinate: CLLocationCoordinate2D {
        guard let lat = lat, let long = long else{
            return CLLocationCoordinate2D()
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    var title: String? {
        name
    }
    
    var subtitle: String? {
        if let cuisines = categories, !cuisines.isEmpty {
            return cuisines.joined(separator: ", ")
        } else {
            return ""
        }
    }
    
    var distance: String?

}
