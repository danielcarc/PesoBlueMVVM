//
//  Model.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//

import Foundation

//struct ChangeResponse: Decodable{
//    
//    var change: [ChangesResponse]
//}

struct ChangesResponse: Decodable{
    
    //let dolarLabel: String?
    let oficial: Oficial?
    let blue: Blue?
    let blue_euro: BlueEuro?
    var last_update: String
    var actualizacion: String{
        
        if let index = last_update.firstIndex(of: "T") {
            let truncatedString = String(self.last_update[..<index])
            let timeString = String(self.last_update[index...])
            
            let timeComponents = timeString.components(separatedBy: ":")
            var primerComponente = timeComponents.first
            _ = primerComponente!.removeFirst()
            let prim = primerComponente
            //print(primerComponente!)
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

struct Oficial: Decodable{
    var dolarLabel: String?
    let value_sell: Double
    let value_buy: Double
}
struct Blue: Decodable{
    var dolarLabel: String?
    let value_sell: Double
    let value_buy: Double
}
struct BlueEuro: Decodable{
    var dolarLabel: String?
    let value_sell: Double
    let value_buy: Double
}
