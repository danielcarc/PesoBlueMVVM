//
//  CurrencyServiceProtocol.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 12/02/2025.
//
import Foundation

protocol CurrencyServiceProtocol{
    func getDolarBlue() async throws -> DolarBlue?
    func getValueForCountry(countryCode: String) async throws -> String
    func getDolarOficial() async throws -> DolarOficial?
    func getDolarMep() async throws -> DolarMEP?
    func getChangeOfCurrencies() async throws -> Rates
}


class CurrencyService: CurrencyServiceProtocol {
    private var rates: Rates?
    private var currencies: [CurrencyItem] = []
    
    
    func getDolarBlue() async throws -> DolarBlue? {
        guard let url = URL(string: APIConfig.dolarBlueURL) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        let jsonDecoder = JSONDecoder()
        let dolarBlue = try jsonDecoder.decode(DolarBlue.self, from: data)
        return dolarBlue
    }

    func getDolarOficial() async throws -> DolarOficial? {
        guard let url = URL(string: APIConfig.dolarOficialURL) else {
            throw APIError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
            throw APIError.invalidResponse
        }
        let jsonDecoder = JSONDecoder()
        let dolarOficial = try jsonDecoder.decode(DolarOficial.self, from: data)
        return dolarOficial
    }

    func getDolarMep() async throws -> DolarMEP? {
        guard let url = URL(string: APIConfig.dolarMepURL) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        let jsonDecoder = JSONDecoder()
        let dolarMep = try jsonDecoder.decode(DolarMEP.self, from: data)
        return dolarMep
    }

    @MainActor /// TODO: Refactor and add support for remaining currencies
    func getValueForCountry(countryCode: String) async throws -> String {
        rates = try await fetchExchangeRates()
        let dolarMep = try await getDolarMep()?.rate ?? "0.0"
        
        var value = Double(dolarMep) ?? 0.0
        switch countryCode {
        case "BR":
            guard let rate = Double(rates?.BRL?.rawRate ?? "0.00") else { return "N/A BRL" }
            value /= rate
        case "UY":
            guard let rate = Double(rates?.UYU?.rawRate ?? "0.00") else { return "N/A UYU" }
            value /= rate
        case "CL":
            guard let rate = Double(rates?.CLP?.rawRate ?? "0.00") else { return "N/A CLP" }
            value /= rate
        case "AR":
            value = Double(dolarMep) ?? 0.0
        default:
            return "Código de país no reconocido"
        }
        
        return String(format: "%.2f", value)
    }
    
    
    //redefinir los metodos para devolver el valor de la divisa individualmente y append al array que los maneja que este array sea de tipo protocolo que acepte los dos tipos de datos
    private func fetchExchangeRates() async throws -> Rates {
        guard let url = URL(string: "\(APIConfig.currencyBaseURL)?api_key=\(APIConfig.apiKey)&from=USD&to=BRL,UYU,CLP,EUR,GBP,COP,JPY,ILS,MXN,PYG,PEN,RUB,CAD,BOB&format=json") else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        let jsonDecoder = JSONDecoder()
        let dlp: Rates = try jsonDecoder.decode(CurrencyResponse.self, from: data).rates
        return dlp
    }
}

extension CurrencyService{
    func getChangeOfCurrencies() async throws -> Rates {

        let currencies: Rates = try await fetchExchangeRates()
        return currencies
    }
}


 
