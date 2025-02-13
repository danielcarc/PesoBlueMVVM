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
}


class CurrencyService: CurrencyServiceProtocol {
    private let currencyUrl = "https://api.getgeoapi.com/v2/currency/convert?api_key="
    private let apiKey = "99f81f10b5b6b92679b9051bdce40b7647f150e0"
    
    private var dolarBlue: DolarBlue?
    
    @MainActor
    func getDolarBlue() async throws -> DolarBlue? {
        guard let url = URL(string: "https://dolarapi.com/v1/dolares/blue") else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        let jsonDecoder = JSONDecoder()
        self.dolarBlue = try jsonDecoder.decode(DolarBlue.self, from: data)
        return self.dolarBlue
    }
    
    @MainActor
    func getValueForCountry(countryCode: String) async throws -> String {
        let rates = try await fetchExchangeRates()
        
        var value = dolarBlue?.venta ?? 0.0
        switch countryCode {
        case "BR":
            guard let rate = Double(rates.BRL.rate ?? "0.00") else { return "N/A BRL" }
            value /= rate
        case "UY":
            guard let rate = Double(rates.UYU.rate ?? "0.00") else { return "N/A UYU" }
            value /= rate
        case "CL":
            guard let rate = Double(rates.CLP.rate ?? "0.00") else { return "N/A CLP" }
            value /= rate
        default:
            return "Código de país no reconocido"
        }
        
        return String(format: "%.2f", value)
    }
    
    private func fetchExchangeRates() async throws -> Rates {
        guard let url = URL(string: "\(currencyUrl)\(apiKey)&from=USD&to=BRL,UYU,CLP&format=json") else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(CurrencyResponse.self, from: data).rates
    }
}
