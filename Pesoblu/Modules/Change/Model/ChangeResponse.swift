//
//  Model.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//

import Foundation

protocol CurrencyItem {
    var currencyTitle: String? {get set}
    var currencyLabel: String? {get set}
    var rate: String? {get}
}

struct ChangesResponse: Decodable{
    
    let oficial: Oficial?
    let blue: Blue?
    let blue_euro: BlueEuro?
    var last_update: String
    /// Formats the ISO 8601 `last_update` string into
        /// `Ultima actualizacion yyyy-MM-dd HH:mm:ss`.
    var actualizacion: String{
        
        if let index = last_update.firstIndex(of: "T") {
            // Separate date and time portions
            let truncatedString = String(self.last_update[..<index])
            let timeString = String(self.last_update[index...])
            
            let timeComponents = timeString.components(separatedBy: ":")
            var primerComponente = timeComponents.first
            _ = primerComponente!.removeFirst()
            let prim = primerComponente
            let segundoComponente = timeComponents[1]
            let tercerComponente = timeComponents[2]
            let tercer = tercerComponente.split(separator: ".")
            let tres = tercer[0]
            let actualizacion = "Ultima actualizacion \(truncatedString) \(prim!):\(segundoComponente):\(tres)"
            return actualizacion
        }
        return last_update
    }
    
}

struct Oficial: Decodable, CurrencyItem{
    var rate: String?{
        return String(format: "%.2f", value_sell)
    }
    
    var currencyTitle: String?
    
    var currencyLabel: String?
    
    var dolarLabel: String?
    let value_sell: Double
    let value_buy: Double
}
struct Blue: Decodable, CurrencyItem{
    var currencyTitle: String?
    var rate: String?{
        return String(value_sell)
    }
    var currencyLabel: String?
    
    var dolarLabel: String?
    let value_sell: Double
    let value_buy: Double
}
struct BlueEuro: Decodable, CurrencyItem{
    var currencyTitle: String?
    var rate: String?{
        return String(value_sell)
    }
    var currencyLabel: String?
    
    var dolarLabel: String?
    let value_sell: Double
    let value_buy: Double
}

/// Representa una conversión genérica de moneda.
struct CurrencyConversion: CurrencyItem {
    var currencyTitle: String?
    var currencyLabel: String?
    var rate: String?
}
