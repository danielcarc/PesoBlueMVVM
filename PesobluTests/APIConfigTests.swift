import XCTest
@testable import Pesoblu

final class APIConfigTests: XCTestCase {
    func test_apiKeyLoadsFromEnvironment() {
        let expected = "test_key"
        setenv("API_KEY", expected, 1)
        defer { unsetenv("API_KEY") }
        XCTAssertEqual(APIConfig.apiKey, expected)
    }
}
