import Foundation
import os.log

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "Pesoblu"
    private static let debugLog = OSLog(subsystem: subsystem, category: "Debug")
    private static let errorLog = OSLog(subsystem: subsystem, category: "Error")

    static func debug(_ message: String) {
        #if DEBUG
        os_log("%{public}@", log: debugLog, type: .debug, message)
        #endif
    }

    static func error(_ message: String) {
        os_log("%{public}@", log: errorLog, type: .error, message)
    }
}

