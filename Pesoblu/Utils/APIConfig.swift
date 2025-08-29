import Foundation

struct APIConfig {
    /// Retrieves the API key from a `Secrets.plist` file bundled with the app or from
    /// the `API_KEY` environment variable. The actual `Secrets.plist` should not be
    /// committed to version control.
    static var apiKey: String {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let key = dict["API_KEY"] as? String {
            return key
        }
        if let envKey = ProcessInfo.processInfo.environment["API_KEY"] {
            return envKey
        }
        AppLogger.error("API_KEY not found. Provide it in Secrets.plist or as an environment variable.")
        return ""
    }

    static let currencyBaseURL = "https://api.getgeoapi.com/v2/currency/convert"
    static let dolarAPIBaseURL = "https://dolarapi.com/v1/dolares"
    static var dolarBlueURL: String { "\(dolarAPIBaseURL)/blue" }
    static var dolarOficialURL: String { "\(dolarAPIBaseURL)/oficial" }
    static var dolarMepURL: String { "\(dolarAPIBaseURL)/bolsa" }
}
