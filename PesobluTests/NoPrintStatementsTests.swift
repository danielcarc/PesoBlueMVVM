import XCTest
import Foundation

final class NoPrintStatementsTests: XCTestCase {
    func testNoPrintStatementsInSource() throws {
        let fileManager = FileManager.default
        let testFileURL = URL(fileURLWithPath: #filePath)
        let projectRoot = testFileURL.deletingLastPathComponent().deletingLastPathComponent()
        let sourceURL = projectRoot.appendingPathComponent("Pesoblu")
        let enumerator = fileManager.enumerator(at: sourceURL, includingPropertiesForKeys: nil)!
        var violations: [String] = []
        for case let fileURL as URL in enumerator {
            guard fileURL.pathExtension == "swift" else { continue }
            let contents = try String(contentsOf: fileURL)
            if contents.contains("print(") {
                violations.append(fileURL.path)
            }
        }
        if !violations.isEmpty {
            XCTFail("Found print statements in: \(violations.joined(separator: ", "))")
        }
    }
}
