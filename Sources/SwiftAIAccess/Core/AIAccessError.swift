import Foundation

/// Comprehensive error types for SwiftAIAccess operations
public enum AIAccessError: Error, LocalizedError {
    /// Invalid identifier format or content
    case invalidIdentifier(String, reason: String? = nil)
    
    /// Element not found in the tracking system
    case elementNotFound(String)
    
    /// Invalid frame or coordinate values
    case invalidFrame(CGRect, reason: String? = nil)
    
    /// Memory or resource limits exceeded
    case resourceLimitExceeded(limit: Int, current: Int)
    
    /// Threading or concurrency issues
    case concurrencyError(String)
    
    /// Configuration or setup errors
    case configurationError(String)
    
    /// Input validation failures
    case validationError(String)
    
    /// Regex pattern compilation or execution errors
    case regexError(String, pattern: String)
    
    /// Accessibility integration errors
    case accessibilityError(String)
    
    /// Generic operational errors with context
    case operationFailed(String, underlyingError: Error? = nil)
    
    public var errorDescription: String? {
        switch self {
        case .invalidIdentifier(let id, let reason):
            if let reason = reason {
                return "Invalid identifier '\(id)': \(reason)"
            }
            return "Invalid identifier '\(id)'"
            
        case .elementNotFound(let id):
            return "Element '\(id)' not found in tracking system"
            
        case .invalidFrame(let frame, let reason):
            if let reason = reason {
                return "Invalid frame \(frame): \(reason)"
            }
            return "Invalid frame coordinates: \(frame)"
            
        case .resourceLimitExceeded(let limit, let current):
            return "Resource limit exceeded: \(current) items (limit: \(limit))"
            
        case .concurrencyError(let message):
            return "Concurrency error: \(message)"
            
        case .configurationError(let message):
            return "Configuration error: \(message)"
            
        case .validationError(let message):
            return "Validation error: \(message)"
            
        case .regexError(let message, let pattern):
            return "Regex error with pattern '\(pattern)': \(message)"
            
        case .accessibilityError(let message):
            return "Accessibility error: \(message)"
            
        case .operationFailed(let message, let underlyingError):
            if let underlyingError = underlyingError {
                return "Operation failed: \(message) (underlying: \(underlyingError.localizedDescription))"
            }
            return "Operation failed: \(message)"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .invalidIdentifier(_, let reason):
            return reason
        case .invalidFrame(_, let reason):
            return reason
        case .operationFailed(_, let underlyingError):
            return underlyingError?.localizedDescription
        default:
            return nil
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidIdentifier:
            return "Use only alphanumeric characters, underscores, and hyphens in identifiers"
            
        case .elementNotFound:
            return "Ensure the element is properly tracked using .applyAIAccess() or manually added to the tracker"
            
        case .invalidFrame:
            return "Provide valid, finite coordinate values for the frame"
            
        case .resourceLimitExceeded:
            return "Consider clearing unused elements or increasing resource limits"
            
        case .concurrencyError:
            return "Ensure UI operations are performed on the main thread"
            
        case .configurationError:
            return "Check your SwiftAIAccess configuration and setup"
            
        case .validationError:
            return "Validate input parameters before calling the API"
            
        case .regexError:
            return "Use a valid regex pattern for element matching"
            
        case .accessibilityError:
            return "Check accessibility configuration and system settings"
            
        case .operationFailed:
            return "Check the underlying error for specific recovery steps"
        }
    }
}

/// Result type for operations that can fail
public typealias AIAccessResult<T> = Result<T, AIAccessError>

/// Validation utilities for common input types
public enum AIAccessValidation {
    /// Maximum number of tracked elements to prevent memory issues
    public static let maxTrackedElements = 10000
    
    /// Maximum identifier length
    public static let maxIdentifierLength = 200
    
    /// Maximum context metadata size (total characters)
    public static let maxContextSize = 5000
    
    /// Validate an identifier format and content
    public static func validateIdentifier(_ identifier: String) throws {
        guard !identifier.isEmpty else {
            throw AIAccessError.invalidIdentifier(identifier, reason: "Identifier cannot be empty")
        }
        
        guard identifier.count <= maxIdentifierLength else {
            throw AIAccessError.invalidIdentifier(identifier, reason: "Identifier too long (max \(maxIdentifierLength) characters)")
        }
        
        // Check for valid characters: alphanumeric, underscore, hyphen, period
        let validPattern = "^[a-zA-Z0-9_.-]+$"
        let regex = try NSRegularExpression(pattern: validPattern)
        let range = NSRange(location: 0, length: identifier.utf16.count)
        
        guard regex.firstMatch(in: identifier, options: [], range: range) != nil else {
            throw AIAccessError.invalidIdentifier(identifier, reason: "Contains invalid characters (use only letters, numbers, _, -, .)")
        }
    }
    
    /// Validate a frame for finite, reasonable values
    public static func validateFrame(_ frame: CGRect) throws {
        guard frame.origin.x.isFinite && frame.origin.y.isFinite &&
              frame.size.width.isFinite && frame.size.height.isFinite else {
            throw AIAccessError.invalidFrame(frame, reason: "Contains infinite or NaN values")
        }
        
        guard frame.size.width >= 0 && frame.size.height >= 0 else {
            throw AIAccessError.invalidFrame(frame, reason: "Width and height must be non-negative")
        }
        
        // Check for reasonable coordinate bounds (prevent overflow issues)
        let maxCoordinate: CGFloat = 1_000_000
        guard abs(frame.origin.x) <= maxCoordinate && abs(frame.origin.y) <= maxCoordinate &&
              frame.size.width <= maxCoordinate && frame.size.height <= maxCoordinate else {
            throw AIAccessError.invalidFrame(frame, reason: "Coordinates exceed reasonable bounds")
        }
    }
    
    /// Validate context metadata size and content
    public static func validateContext(_ context: [String: String]) throws {
        let totalSize = context.reduce(0) { sum, pair in
            sum + pair.key.count + pair.value.count
        }
        
        guard totalSize <= maxContextSize else {
            throw AIAccessError.validationError("Context metadata too large: \(totalSize) characters (max \(maxContextSize))")
        }
        
        // Validate individual keys and values
        for (key, value) in context {
            guard !key.isEmpty else {
                throw AIAccessError.validationError("Context keys cannot be empty")
            }
            
            // Check for potentially sensitive data patterns
            let sensitivePatterns = ["password", "token", "secret", "key", "credential"]
            let lowercaseKey = key.lowercased()
            let lowercaseValue = value.lowercased()
            
            for pattern in sensitivePatterns {
                if lowercaseKey.contains(pattern) || lowercaseValue.contains(pattern) {
                    throw AIAccessError.validationError("Context appears to contain sensitive data: '\(key)'")
                }
            }
        }
    }
    
    /// Validate regex pattern
    public static func validateRegexPattern(_ pattern: String) throws -> NSRegularExpression {
        do {
            return try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch {
            throw AIAccessError.regexError("Invalid regex pattern", pattern: pattern)
        }
    }
}