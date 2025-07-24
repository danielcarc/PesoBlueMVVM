//
//  DolarBlueModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 18/12/2024.
//


struct DolarBlue: Codable {
    var moneda: String
    var casa: String
    var nombre: String
    var compra: Double
    var venta: Double
    var fechaActualizacion: String
    
    enum CodingKeys: String, CodingKey {
        case moneda
        case casa
        case nombre
        case compra
        case venta
        case fechaActualizacion
    }
}
