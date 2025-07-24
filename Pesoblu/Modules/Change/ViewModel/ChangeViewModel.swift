//
//  ChangeViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 04/10/23.
//

import Foundation

protocol ChangeViewModelDelegate: AnyObject{
    func didFinish()
    func didFail(error: Error)
}

@MainActor
protocol ChangeViewModelProtocol{
    func getChangeOfCurrencies()
    var delegate : ChangeViewModelDelegate? {get set}
    var currencies: [CurrencyItem]{get set}
}


class ChangeViewModel: ChangeViewModelProtocol{
    
    
    private let currencyService: CurrencyServiceProtocol
    var currencies: [CurrencyItem]
    var rates : Rates
    var delegate: ChangeViewModelDelegate?
    
    init(delegate: ChangeViewModelDelegate? = nil, currencyService: CurrencyServiceProtocol, currencies: [CurrencyItem], rates: Rates) {
        self.delegate = delegate
       
        self.currencyService = currencyService
        self.currencies = currencies
        self.rates = rates
    }
    
    
    
    var changeArray = ["Oficial", "Blue", "Euro Blue"]
    
    @MainActor
    func getChangeOfCurrencies() {
        
        Task{
            await fetchCurrencies()
        }
    }
    
    private func fetchCurrencies() async {
        do{
            
            if var mep = try await currencyService.getDolarMep(){
                
                mep.currencyTitle = "USD MEP - Dólar Americano"
                mep.currencyLabel = "Dólar Bolsa de Valores / MEP"
                currencies.append(mep)
                rates = try await currencyService.getChangeOfCurrencies()
                currencies.append(getUyuValue(currency: mep.venta))
                currencies.append(getBrlValue(currency: mep.venta))
                currencies.append(getClpValue(currency: mep.venta))
                currencies.append(getEurValue(currency: mep.venta))
                currencies.append(getMxnValue(currency: mep.venta))
                currencies.append(getCopValue(currency: mep.venta))
                currencies.append(getGbpValue(currency: mep.venta))
                currencies.append(getJpyValue(currency: mep.venta))
                currencies.append(getIlsValue(currency: mep.venta))
                currencies.append(getPygValue(currency: mep.venta))
                currencies.append(getPenValue(currency: mep.venta))
                currencies.append(getRubValue(currency: mep.venta))
                currencies.append(getCadValue(currency: mep.venta))
                currencies.append(getBobValue(currency: mep.venta))
                self.delegate?.didFinish()
            }
        }
        catch{
            delegate?.didFail(error: error)
        }
        
    }
}

//MARK: - Currency Methods

extension ChangeViewModel{
    
    func getUyuValue(currency: Double) -> Uyu {
        var uyu: Uyu
        if let uy = rates.UYU {
            uyu = uy
        } else {
            uyu = Uyu(rawRate: "0.0")
        }
        let rateValue = Double(uyu.rawRate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        uyu.rawRate = String(result)
        uyu.currencyTitle = "UYU - Peso Uruguayo"
        uyu.currencyLabel = "Uruguay"
        return uyu
    }
    
    func getBrlValue(currency: Double) -> Brl {
        var brl: Brl
        if let br = rates.BRL {
            brl = br
        } else {
            brl = Brl(rawRate: "0.0")
        }
        let rateValue = Double(brl.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        brl.rawRate = String(result)
        brl.currencyTitle = "BRL - Real Brasil"
        brl.currencyLabel = "Brasil"
        return brl
    }
    
    func getClpValue(currency: Double) -> Clp {
        var clp: Clp
        if let cl = rates.CLP {
            clp = cl
        } else {
            clp = Clp(rawRate: "0.0")
        }
        let rateValue = Double(clp.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        clp.rawRate = String(result)
        clp.currencyTitle = "CLP - Peso Chileno"
        clp.currencyLabel = "Chile"
        return clp
    }
    
    func getEurValue(currency: Double) -> Eur {
        var eur: Eur
        if let eu = rates.EUR {
            eur = eu
        } else {
            eur = Eur(rawRate: "0.0")
        }
        let rateValue = Double(eur.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        eur.rawRate = String(result)
        eur.currencyTitle = "EUR - Euro"
        eur.currencyLabel = "Unión Europea"
        return eur
    }
    
    func getCopValue(currency: Double) -> Cop {
        var cop: Cop
        if let co = rates.COP {
            cop = co
        } else {
            cop = Cop(rawRate: "0.0")
        }
        let rateValue = Double(cop.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        cop.rawRate = String(result)
        cop.currencyTitle = "COP - Peso Colombiano"
        cop.currencyLabel = "Colombia"
        return cop
    }
    
    func getGbpValue(currency: Double) -> Gbp {
        var gbp: Gbp
        if let gb = rates.GBP {
            gbp = gb
        } else {
            gbp = Gbp(rawRate: "0.0")
        }
        let rateValue = Double(gbp.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        gbp.rawRate = String(result)
        gbp.currencyTitle = "GBP - Libra Esterlina Britanica"
        gbp.currencyLabel = "Reino Unido"
        return gbp
    }
    
    func getJpyValue(currency: Double) -> Jpy {
        var jpy: Jpy
        if let jp = rates.JPY {
            jpy = jp
        } else {
            jpy = Jpy(rawRate: "0.0")
        }
        let rateValue = Double(jpy.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        jpy.rawRate = String(result)
        jpy.currencyTitle = "JPY - Yen Japonés"
        jpy.currencyLabel = "Japón"
        return jpy
    }
    
    func getIlsValue(currency: Double) -> Ils {
        var ils: Ils
        if let il = rates.ILS {
            ils = il
        } else {
            ils = Ils(rawRate: "0.0")
        }
        let rateValue = Double(ils.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        ils.rawRate = String(result)
        ils.currencyTitle = "ILS - Shequel Israelí"
        ils.currencyLabel = "Israel"
        return ils
    }
    
    func getMxnValue(currency: Double) -> Mxn {
        var mxn: Mxn
        if let mx = rates.MXN {
            mxn = mx
        } else {
            mxn = Mxn(rawRate: "0.0")
        }
        let rateValue = Double(mxn.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        mxn.rawRate = String(result)
        mxn.currencyTitle = "MXN - Peso Mexicano"
        mxn.currencyLabel = "México"
        return mxn
    }
    
    func getPygValue(currency: Double) -> Pyg {
        var pyg: Pyg
        if let py = rates.PYG {
            pyg = py
        } else {
            pyg = Pyg(rawRate: "0.0")
        }
        let rateValue = Double(pyg.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        pyg.rawRate = String(result)
        pyg.currencyTitle = "PYG - Guaraní Paraguayo"
        pyg.currencyLabel = "Paraguay"
        return pyg
    }
    
    func getPenValue(currency: Double) -> Pen {
        var pen: Pen
        if let pe = rates.PEN {
            pen = pe
        } else {
            pen = Pen(rawRate: "0.0")
        }
        let rateValue = Double(pen.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        pen.rawRate = String(result)
        pen.currencyTitle = "PEN - Sol Peruano"
        pen.currencyLabel = "Perú"
        return pen
    }
    
    func getRubValue(currency: Double) -> Rub {
        var rub: Rub
        if let ru = rates.RUB {
            rub = ru
        } else {
            rub = Rub(rawRate: "0.0")
        }
        let rateValue = Double(rub.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        rub.rawRate = String(result)
        rub.currencyTitle = "RUB - Rublo Ruso"
        rub.currencyLabel = "Rusia"
        return rub
    }
    
    func getCadValue(currency: Double) -> Cad {
        var cad: Cad
        if let ca = rates.CAD {
            cad = ca
        } else {
            cad = Cad(rawRate: "0.0")
        }
        let rateValue = Double(cad.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        cad.rawRate = String(result)
        cad.currencyTitle = "CAD - Dólar Canadiense"
        cad.currencyLabel = "Canadá"
        return cad
    }
    
    func getBobValue(currency: Double) -> Bob {
        var bob: Bob
        if let bo = rates.BOB {
            bob = bo
        } else {
            bob = Bob(rawRate: "0.0")
        }
        let rateValue = Double(bob.rate ?? "0.0") ?? 0.0
        let result = rateValue != 0 ? currency / rateValue : 0.0
        bob.rawRate = String(result)
        bob.currencyTitle = "BOB - Boliviano"
        bob.currencyLabel = "Bolivia"
        return bob
    }
}
