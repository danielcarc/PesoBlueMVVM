//
//  HomeViewModel.swift
//  PesoBlueMVVM
//
//  Created by Daniel Carcacha on 10/12/2024.
//

import Foundation


class HomeViewModel{
    
    private var discoverItems: [DiscoverItem] = []
    private var citysItem: [CitysItem] = []
    private var dolarBlue: DolarBlue?
    private var currency : Rates = Rates(BRL: Brl(rate: nil), CLP: Clp(rate: nil), UYU: Uyu(rate: nil))
    
    let currencyUrl = "https://api.getgeoapi.com/v2/currency/convert?api_key="
    let apiKey = "99f81f10b5b6b92679b9051bdce40b7647f150e0"
    
    
    var discoverManager = DiscoverDataManager()
    var citysManager = CitysDataManager()
    var placeService = PlaceService()
    
    func fetchCitysItems() -> [CitysItem]{
        citysItem = citysManager.fetch()
        return citysItem
    }
    
    func fetchDiscoverItems() -> [DiscoverItem]{
        discoverItems = discoverManager.fetch()
        return discoverItems
    }
    
    
    @MainActor
    func getDolarBlue() async -> DolarBlue?{
        
        do {
            guard let url = URL(string: "https://dolarapi.com/v1/dolares/blue") else {
                print("URL inválida")
                return nil
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error en response")
                return nil
            }
            
            let jsonDecoder = JSONDecoder()
            let dolarBlue = try jsonDecoder.decode(DolarBlue.self, from: data)
            self.dolarBlue = dolarBlue
            //print(dolarBlue.venta)
            return dolarBlue
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func countryCode(){
        if let countryCode = getUserCountry() {
            print("Código del país: \(countryCode)") // Ejemplo: "BR" para Brasil
        } else {
            print("No se pudo determinar el país.")
        }
    }
    
    func getUserCountry() -> String? {
        let identifier = Locale.current.identifier // Ejemplo: "en_BR"
        let components = identifier.split(separator: "_")
        if components.count > 1 {
            return String(components[1]) // Devuelve "BR"
        }
        return nil // Si no hay región, devuelve nil
    }
    
    @MainActor
    func fetchChange() async -> Rates?{
        
        do{
            guard let url = URL(string: "\(currencyUrl)\(apiKey)&from=USD&to=BRL,UYU,CLP&format=json") else {
                print("URL inválida")
                return nil
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    print("Error en response: \(httpResponse.statusCode)")
                    return nil
                }
            } else {
                print("Error en el formato de respuesta")
                return nil
            }
            
            let jsonDecoder = JSONDecoder()
            
            let currencyData = try jsonDecoder.decode(CurrencyResponse.self, from: data)
            self.currency = currencyData.rates
            return self.currency
            //await self.delegate?.didFinish()
            //print(currency)
        }
        catch{
            //self.delegate?.didFail(error: error)
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getValueForCountry(countryCode: String) async -> String {
        guard let currentRates = await fetchChange() else {
            return "Datos no disponibles" // Mensaje más descriptivo cuando no hay datos
        }
        
        var value = dolarBlue?.venta ?? 0.0 // Usar valor por defecto si `dolarBlue?.venta` es `nil`
        
        switch countryCode {
        case "BR":
            guard let rateBRL = Double(currentRates.BRL.rate ?? "0.00") else {
                return "N/A BRL"
            }
            value /= rateBRL
        case "UY":
            guard let rateUYU = Double(currentRates.UYU.rate ?? "0.00") else {
                return "N/A UYU"
            }
            value /= rateUYU
        case "CL":
            guard let rateCLP = Double(currentRates.CLP.rate ?? "0.00") else {
                return "N/A CLP"
            }
            value /= rateCLP
        default:
            return "Código de país no reconocido" // Mensaje más descriptivo para código de país no válido
        }
        
        return String(format: "%.2f", value) // Redondear y dar formato al valor resultante
    }
    
    

}
extension HomeViewModel{
    
    func filteredItem(item: DiscoverItem) throws -> [PlaceItem] {
        let filter = item.name
        
        let filteredPlaces = try filterPlaces(by: filter)
        
        if filteredPlaces.isEmpty {
            print("Advertencia: No se encontraron lugares para el tipo '\(filter)'.")
        }
        
        return filteredPlaces
    }

    
    func filterPlaces(by type: String) throws -> [PlaceItem] {
        let places = try placeService.fetchPlaces() // Supongamos que fetchPlaces puede lanzar un error
        
        guard !places.isEmpty else {
            throw PlaceError.noPlacesAvailable
        }
        
        let filteredPlaces = places.filter { $0.placeType.lowercased() == type.lowercased() }
        
        return filteredPlaces
    }
    
}

