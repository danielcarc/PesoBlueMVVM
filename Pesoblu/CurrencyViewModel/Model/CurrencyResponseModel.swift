//
//  Model.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//

import Foundation

struct CurrencyResponse: Decodable{
    let rates: Rates

    enum CodingKeys: String, CodingKey{
        case rates //= "rates"
    }
}
struct Rates: Decodable{
    var BRL: Brl?
    var CLP: Clp?
    var UYU: Uyu?
    var EUR: Eur?
    var GBP: Gbp?
    var COP: Cop?
    var JPY: Jpy?
    var ILS: Ils?
    var MXN: Mxn?
    var PYG: Pyg?
    var PEN: Pen?
    var RUB: Rub?
    var CAD: Cad?
    var BOB: Bob?
    
    enum CodingKeys: String, CodingKey{
        case BRL = "BRL"
        case CLP = "CLP"
        case UYU = "UYU"
        case EUR = "EUR"
        case GBP = "GBP"
        case COP = "COP"
        case JPY = "JPY"
        case ILS = "ILS"
        case MXN = "MXN"
        case PYG = "PYG"
        case PEN = "PEN"
        case RUB = "RUB"
        case CAD = "CAD"
        case BOB = "BOB"
    }
    init(){
        self.BRL = nil
        self.CLP = nil
        self.UYU = nil
        self.EUR = nil
        self.GBP = nil
        self.COP = nil
        self.JPY = nil
        self.ILS = nil
        self.MXN = nil
        self.PYG = nil
        self.PEN = nil
        self.RUB = nil
        self.CAD = nil
        self.BOB = nil
    }
}

struct Bob: Decodable, CurrencyItem{
    var currencyTitle: String?
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Cad: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Rub: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Pen: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Pyg: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Mxn: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Ils: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Jpy: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Eur: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Gbp: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Cop: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Brl: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Clp: Decodable, CurrencyItem{
    var currencyTitle: String?
    
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}
struct Uyu: Decodable, CurrencyItem{
    var currencyTitle: String?
    var currencyLabel: String?
    var rawRate: String?
    
    enum CodingKeys: String, CodingKey{
        case rawRate = "rate"
    }
    var rate: String?{
        return rawRate ?? "0.0"
    }
}

//struct ExchangeRate: Decodable {
//    let compra: Double?
//    let venta: Double?
//    let casa: String?
//    let nombre: String?
//    let moneda: String?
//    let fechaActualizacion: String?
//}

