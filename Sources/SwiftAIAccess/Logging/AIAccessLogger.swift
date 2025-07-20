import Foundation
import os

/// A centralized logging system for AI accessibility events.
///
/// Provides structured logging that can be parsed by AI agents and analytics tools.
public class AIAccessLogger {
    /// Shared singleton instance
    public static let shared = AIAccessLogger()
    
    /// Available log categories
    public enum Category: String {
        case interaction = "interaction"
        case navigation = "navigation"
        case state = "state"
        case performance = "performance"
        case debug = "debug"
    }
    
    private let subsystem = "com.swiftaiaccess"
    private var loggers: [Category: Logger] = [:]
    
    /// Whether logging is enabled
    public var isEnabled: Bool = true
    
    /// Log level threshold
    public var logLevel: OSLogType = .info
    
    private init() {
        // Initialize loggers for each category
        for category in Category.allCases {
            loggers[category] = Logger(subsystem: subsystem, category: category.rawValue)
        }
    }
    
    /// Log a user interaction event
    public func logInteraction(
        identifier: String,
        action: String,
        context: [String: String] = [:],
        file: String = #file,
        line: Int = #line
    ) {
        guard isEnabled else { return }
        
        let logger = loggers[.interaction] ?? Logger()
        let contextString = context.isEmpty ? "" : ", context: \(context)"
        
        logger.info("🎯 \(action) interaction: \(identifier)\(contextString)")
        
        #if DEBUG
        print("[AIAccess] 🎯 \(action) interaction: \(identifier)\(contextString)")
        #endif
    }
    
    /// Log a navigation event
    public func logNavigation(
        from: String? = nil,
        to: String,
        method: String = "unknown",
        context: [String: String] = [:]
    ) {
        guard isEnabled else { return }
        
        let logger = loggers[.navigation] ?? Logger()
        let fromString = from.map { " from \($0)" } ?? ""
        
        logger.info("🚀 Navigation\(fromString) to \(to) via \(method)")
    }
    
    /// Log a state change
    public func logStateChange(
        component: String,
        from: String,
        to: String,
        context: [String: String] = [:]
    ) {
        guard isEnabled else { return }
        
        let logger = loggers[.state] ?? Logger()
        logger.info("🔄 State change in \(component): \(from) → \(to)")
    }
    
    /// Log performance metrics
    public func logPerformance(
        operation: String,
        duration: TimeInterval,
        context: [String: String] = [:]
    ) {
        guard isEnabled else { return }
        
        let logger = loggers[.performance] ?? Logger()
        let durationMs = Int(duration * 1000)
        logger.info("⚡ Performance: \(operation) completed in \(durationMs)ms")
    }
    
    /// Log debug information
    public func debug(
        _ message: String,
        context: [String: String] = [:],
        file: String = #file,
        line: Int = #line
    ) {
        guard isEnabled else { return }
        
        let logger = loggers[.debug] ?? Logger()
        logger.debug("🔍 \(message)")
        
        #if DEBUG
        print("[AIAccess-Debug] 🔍 \(message) [\(URL(fileURLWithPath: file).lastPathComponent):\(line)]")
        #endif
    }
}

// MARK: - CaseIterable Extension
extension AIAccessLogger.Category: CaseIterable {}