//
//  CurrencyServiceProtocol.swift
//  Pesoblu
//
//  Created by Daniel Carcacha on 12/02/2025.
//
import Foundation
import Alamofire

protocol CurrencyServiceProtocol{
    func getDolarBlue() async throws -> DolarBlue?
    func getValueForCountry(countryCode: String) async throws -> String
    func getDolarOficial() async throws -> DolarOficial?
    func getDolarMep() async throws -> DolarMEP?
    func getChangeOfCurrencies() async throws -> Rates
}


class CurrencyService: CurrencyServiceProtocol {
    private let currencyUrl = "https://api.getgeoapi.com/v2/currency/convert?api_key="
    private let apiKey = "99f81f10b5b6b92679b9051bdce40b7647f150e0"
    
    private var dolarBlue: DolarBlue?
    //private var dolarOficial: DolarOficial?
    //private var dolarMep: DolarMEP?
    private var rates: Rates?
    private var currencies: [CurrencyItem] = []
    
    
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
        let dolarBlue = try jsonDecoder.decode(DolarBlue.self, from: data)
        return dolarBlue
    }
    
    @MainActor
    func getDolarOficial() async throws -> DolarOficial? {
        guard let url = URL(string: "https://dolarapi.com/v1/dolares/oficial")else {
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
    
    @MainActor
    func getDolarMep() async throws -> DolarMEP? {
        let url = "https://dolarapi.com/v1/dolares/bolsa"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DolarMEP.self) { response in
                    switch response.result {
                    case .success(let dolarMep):
                        //self.dolarMep = dolarMep
                        continuation.resume(returning: dolarMep)
                    case .failure(let error):
                        if let afError = error.asAFError {
                            if afError.responseCode == nil {
                                continuation.resume(throwing: APIError.invalidURL)
                            } else {
                                continuation.resume(throwing: APIError.invalidResponse)
                            }
                        } else {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }
    
    
    @MainActor
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
        default:
            return "Código de país no reconocido"
        }
        
        return String(format: "%.2f", value)
    }
    
    
    //redefinir los metodos para devolver el valor de la divisa individualmente y append al array que los maneja que este array sea de tipo protocolo que acepte los dos tipos de datos
    private func fetchExchangeRates() async throws -> Rates {
        guard let url = URL(string: "\(currencyUrl)\(apiKey)&from=USD&to=BRL,UYU,CLP,EUR,GBP,COP,JPY,ILS,MXN,PYG,PEN,RUB,CAD,BOB&format=json") else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        let jsonDecoder = JSONDecoder()
        let dlp: Rates = try jsonDecoder.decode(CurrencyResponse.self, from: data).rates
        print (dlp)
        //return try jsonDecoder.decode(CurrencyResponse.self, from: data).rates
        return dlp
    }
}

extension CurrencyService{
    func getChangeOfCurrencies() async throws -> Rates {

        var currencies : Rates
        currencies = try await fetchExchangeRates()
        return currencies
    }
}


 
