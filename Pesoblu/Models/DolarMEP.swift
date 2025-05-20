//
//  DolarMEP.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 01/05/2025.
//

struct DolarMEP: Decodable, CurrencyItem{
    var currencyTitle: String?
    var currencyLabel: String?
    
    let moneda: String
    let casa: String
    let nombre: String
    let compra: Double
    let venta: Double
    let fechaActualizacion: String
    
    enum CodingKeys: String, CodingKey {
        
        case currencyTitle
        case currencyLabel
        case moneda = "moneda"
        case casa = "casa"
        case nombre = "nombre"
        case compra = "compra"
        case venta = "venta"
        case fechaActualizacion = "fechaActualizacion"
    }
    var rate: String? {
        return String(venta)
    }
}
