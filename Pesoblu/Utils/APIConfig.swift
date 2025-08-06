import Foundation

struct APIConfig {
    static let apiKey = "99f81f10b5b6b92679b9051bdce40b7647f150e0"
    static let currencyBaseURL = "https://api.getgeoapi.com/v2/currency/convert"
    static let dolarAPIBaseURL = "https://dolarapi.com/v1/dolares"
    static var dolarBlueURL: String { "\(dolarAPIBaseURL)/blue" }
    static var dolarOficialURL: String { "\(dolarAPIBaseURL)/oficial" }
    static var dolarMepURL: String { "\(dolarAPIBaseURL)/bolsa" }
}
