//
//  RestaurantItem.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 06/12/2024.
//


import UIKit
import MapKit



class PlaceItem: NSObject, Decodable, MKAnnotation{
    
    let id: String?
    let name: String?
    let address: String?
    let city: String?
    let state: String?
    let area: String?
    let postalcode: String?
    let country: String?
    let phone: Int?
    let lat: Double?
    let long: Double?
    let price: String?
    let cuisines: [String]
    let instagram: String?
    let imageurl: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case city
        case state
        case area
        case lat
        case long
        case postalcode = "postal_code"
        case country
        case phone
        case price
        case cuisines
        case instagram
        case imageurl = "image_url"
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
        if cuisines.isEmpty {
            return ""
        } else if cuisines.count == 1 {
            return cuisines.first
        } else {
            return cuisines.joined(separator: ", ")
        }
    }

}
