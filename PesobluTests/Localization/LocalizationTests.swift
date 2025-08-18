import XCTest
@testable import Pesoblu

final class LocalizationTests: XCTestCase {
    private func localizedString(_ key: String, locale: String) -> String {
        let path = Bundle.main.path(forResource: locale, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }

    func testHomeTitleChangesWithLocale() {
        let esTitle = localizedString("home_title", locale: "es")
        let enTitle = localizedString("home_title", locale: "en")
        XCTAssertNotEqual(esTitle, enTitle)
    }
}
