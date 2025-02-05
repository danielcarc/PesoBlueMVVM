//
//  DolarBlueModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 18/12/2024.
//


struct DolarBlue: Codable {
    let moneda: String
    let casa: String
    let nombre: String
    let compra: Double
    let venta: Double
    let fechaActualizacion: String
    
    enum CodingKeys: String, CodingKey {
        case moneda
        case casa
        case nombre
        case compra
        case venta
        case fechaActualizacion
    }
}
