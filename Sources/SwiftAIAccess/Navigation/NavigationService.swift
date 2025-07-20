import Foundation
import SwiftUI

/// High-level navigation service for AI automation.
///
/// This service provides a simple API for AI agents to navigate and interact
/// with your app programmatically.
public class NavigationService {
    /// Shared singleton instance
    public static let shared = NavigationService()
    
    /// Navigation result types
    public enum NavigationResult {
        case success
        case elementNotFound(identifier: String)
        case timeout
        case error(Error)
    }
    
    /// Interaction callbacks for integration with automation tools
    public var onElementTap: ((String, CGPoint) -> Void)?
    public var onTextInput: ((String, String) -> Void)?
    public var onSwipe: ((CGPoint, CGPoint) -> Void)?
    
    private let tracker = CoordinateTracker.shared
    private let logger = AIAccessLogger.shared
    
    private init() {}
    
    /// Tap on an element by identifier
    /// - Parameters:
    ///   - identifier: Element identifier
    ///   - completion: Completion handler with result
    public func tapElement(
        _ identifier: String,
        completion: @escaping (NavigationResult) -> Void
    ) {
        guard let element = tracker.findElement(identifier: identifier) else {
            logger.debug("Element not found: \(identifier)")
            completion(.elementNotFound(identifier: identifier))
            return
        }
        
        let center = element.center
        logger.logInteraction(
            identifier: identifier,
            action: "tap",
            context: ["x": "\(Int(center.x))", "y": "\(Int(center.y))"]
        )
        
        // Call the tap callback if set (for integration with automation tools)
        onElementTap?(identifier, center)
        
        completion(.success)
    }
    
    /// Type text into an input field
    /// - Parameters:
    ///   - identifier: Field identifier
    ///   - text: Text to type
    ///   - completion: Completion handler with result
    public func typeText(
        in identifier: String,
        text: String,
        completion: @escaping (NavigationResult) -> Void
    ) {
        guard tracker.findElement(identifier: identifier) != nil else {
            logger.debug("Input field not found: \(identifier)")
            completion(.elementNotFound(identifier: identifier))
            return
        }
        
        logger.logInteraction(
            identifier: identifier,
            action: "type",
            context: ["text": text, "length": "\(text.count)"]
        )
        
        // Call the text input callback if set
        onTextInput?(identifier, text)
        
        completion(.success)
    }
    
    /// Perform a swipe gesture
    /// - Parameters:
    ///   - from: Starting point
    ///   - to: Ending point
    ///   - completion: Completion handler with result
    public func swipe(
        from: CGPoint,
        to: CGPoint,
        completion: @escaping (NavigationResult) -> Void
    ) {
        logger.logInteraction(
            identifier: "gesture",
            action: "swipe",
            context: [
                "from": "(\(Int(from.x)), \(Int(from.y)))",
                "to": "(\(Int(to.x)), \(Int(to.y)))"
            ]
        )
        
        // Call the swipe callback if set
        onSwipe?(from, to)
        
        completion(.success)
    }
    
    /// Find elements matching a pattern
    /// - Parameter pattern: Regex pattern to match identifiers
    /// - Returns: Array of matching element identifiers
    public func findElements(matching pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            return tracker.trackedElements.keys.filter { identifier in
                let range = NSRange(location: 0, length: identifier.utf16.count)
                return regex.firstMatch(in: identifier, options: [], range: range) != nil
            }
        } catch {
            logger.debug("Invalid regex pattern: \(pattern)")
            return []
        }
    }
    
    /// Wait for an element to appear
    /// - Parameters:
    ///   - identifier: Element identifier
    ///   - timeout: Maximum wait time in seconds
    ///   - completion: Completion handler with result
    public func waitForElement(
        _ identifier: String,
        timeout: TimeInterval = 5.0,
        completion: @escaping (NavigationResult) -> Void
    ) {
        let startTime = Date()
        
        func checkElement() {
            if tracker.findElement(identifier: identifier) != nil {
                completion(.success)
                return
            }
            
            if Date().timeIntervalSince(startTime) > timeout {
                completion(.timeout)
                return
            }
            
            // Check again after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                checkElement()
            }
        }
        
        checkElement()
    }
    
    /// Get current view context
    /// - Returns: Current view name and metadata
    public func getCurrentContext() -> (view: String?, metadata: [String: String]) {
        (tracker.currentViewContext, tracker.viewContextMetadata)
    }
    
    /// Get all visible elements
    /// - Returns: Dictionary of all tracked elements
    public func getAllElements() -> [String: CoordinateTracker.TrackedElement] {
        tracker.trackedElements
    }
}