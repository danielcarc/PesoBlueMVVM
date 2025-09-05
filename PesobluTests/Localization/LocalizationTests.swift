import XCTest
@testable import Pesoblu

final class LocalizationTests: XCTestCase {
    func testAllLocalizedStringsExistAndAreNonEmptyInAllSupportedLanguages() {
        let bundle = Bundle.main
        let localizations = bundle.localizations.filter { $0 != "Base" }
        
        var dictionaries: [String: [String: String]] = [:]
        var allKeys = Set<String>()
        
        for locale in localizations {
            guard let path = bundle.path(forResource: locale, ofType: "lproj"),
                  let dict = NSDictionary(contentsOfFile: "\(path)/Localizable.strings") as? [String: String] else {
                XCTFail("Missing Localizable.strings for locale \(locale)")
                continue
            }
            dictionaries[locale] = dict
            allKeys.formUnion(dict.keys)
        }
        
        for key in allKeys {
            for locale in localizations {
                guard let value = dictionaries[locale]?[key] else {
                    XCTFail("Missing key '\(key)' in \(locale).lproj")
                    continue
                }
                XCTAssertFalse(value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                               "Empty value for key '\(key)' in \(locale).lproj")
            }
        }
    }
}

