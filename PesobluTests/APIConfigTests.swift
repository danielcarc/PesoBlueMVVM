import XCTest
@testable import Pesoblu

final class APIConfigTests: XCTestCase {
    func test_apiKeyLoadsFromEnvironment() {
        let expected = "99f81f10b5b6b92679b9051bdce40b7647f150e0"
        setenv("API_KEY", expected, 1)
        defer { unsetenv("API_KEY") }
        XCTAssertEqual(APIConfig.apiKey, expected)
    }
}
