import SwiftUI
import os

/// Tracks UI element coordinates for AI-powered navigation and automation.
///
/// This singleton maintains a real-time map of UI elements and their positions,
/// enabling AI agents to accurately interact with the interface.
public class CoordinateTracker: ObservableObject {
    /// Shared singleton instance
    public static let shared = CoordinateTracker()
    
    /// Information about a tracked UI element
    public struct TrackedElement {
        public let identifier: String
        public let frame: CGRect
        public let context: [String: String]
        public let timestamp: Date
        
        /// Center point of the element
        public var center: CGPoint {
            CGPoint(x: frame.midX, y: frame.midY)
        }
    }
    
    /// Currently tracked elements
    @Published public private(set) var trackedElements: [String: TrackedElement] = [:]
    
    /// Current view context
    @Published public private(set) var currentViewContext: String?
    
    /// Additional view context metadata
    @Published public private(set) var viewContextMetadata: [String: String] = [:]
    
    private let logger = Logger(subsystem: "com.swiftaiaccess", category: "tracking")
    private let queue = DispatchQueue(label: "com.swiftaiaccess.tracking", attributes: .concurrent)
    
    private init() {}
    
    /// Update or add a tracked element (backward compatible, logs errors instead of throwing)
    /// - Parameters:
    ///   - identifier: Unique identifier for the element
    ///   - frame: Frame coordinates of the element
    ///   - context: Additional metadata for the element
    public func updateElement(
        identifier: String,
        frame: CGRect,
        context: [String: String] = [:]
    ) {
        do {
            try updateElementValidated(identifier: identifier, frame: frame, context: context)
        } catch let error as AIAccessError {
            logger.error("Failed to update element '\(identifier)': \(error.localizedDescription)")
            // Continue with best effort - add element anyway for backward compatibility
            let element = TrackedElement(
                identifier: identifier,
                frame: frame,
                context: context,
                timestamp: Date()
            )
            _updateElementUnsafe(element)
        } catch {
            logger.error("Unexpected error updating element '\(identifier)': \(error.localizedDescription)")
            // Continue with best effort
            let element = TrackedElement(
                identifier: identifier,
                frame: frame,
                context: context,
                timestamp: Date()
            )
            _updateElementUnsafe(element)
        }
    }
    
    /// Update or add a tracked element with full validation
    /// - Parameters:
    ///   - identifier: Unique identifier for the element
    ///   - frame: Frame coordinates of the element
    ///   - context: Additional metadata for the element
    /// - Throws: `AIAccessError` if validation fails
    public func updateElementValidated(
        identifier: String,
        frame: CGRect,
        context: [String: String] = [:]
    ) throws {
        // Validate inputs
        try AIAccessValidation.validateIdentifier(identifier)
        try AIAccessValidation.validateFrame(frame)
        try AIAccessValidation.validateContext(context)
        
        // Check resource limits
        if trackedElements.count >= AIAccessValidation.maxTrackedElements && trackedElements[identifier] == nil {
            throw AIAccessError.resourceLimitExceeded(
                limit: AIAccessValidation.maxTrackedElements,
                current: trackedElements.count
            )
        }
        
        let element = TrackedElement(
            identifier: identifier,
            frame: frame,
            context: context,
            timestamp: Date()
        )
        
        _updateElementUnsafe(element)
    }
    
    /// Internal method to update element without validation
    private func _updateElementUnsafe(_ element: TrackedElement) {
        // If we're already on main thread, update synchronously to support tests
        if Thread.isMainThread {
            trackedElements[element.identifier] = element
            
            #if DEBUG
            logger.debug("📍 Updated element: \(element.identifier) at (\(Int(element.frame.midX)), \(Int(element.frame.midY)))")
            #endif
        } else {
            // Use barrier for write operations to ensure thread safety from background threads
            queue.async(flags: .barrier) { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.trackedElements[element.identifier] = element
                }
                
                #if DEBUG
                self.logger.debug("📍 Updated element: \(element.identifier) at (\(Int(element.frame.midX)), \(Int(element.frame.midY)))")
                #endif
            }
        }
    }
    
    /// Remove a tracked element
    public func removeElement(identifier: String) {
        if Thread.isMainThread {
            trackedElements.removeValue(forKey: identifier)
        } else {
            queue.async(flags: .barrier) { [weak self] in
                DispatchQueue.main.async {
                    self?.trackedElements.removeValue(forKey: identifier)
                }
            }
        }
    }
    
    /// Update the current view context
    public func updateViewContext(name: String, metadata: [String: String] = [:]) {
        if Thread.isMainThread {
            currentViewContext = name
            viewContextMetadata = metadata
            logger.info("📱 View context updated: \(name)")
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.currentViewContext = name
                self?.viewContextMetadata = metadata
                self?.logger.info("📱 View context updated: \(name)")
            }
        }
    }
    
    /// Find an element by identifier
    public func findElement(identifier: String) -> TrackedElement? {
        trackedElements[identifier]
    }
    
    /// Find elements matching a predicate
    public func findElements(matching predicate: (TrackedElement) -> Bool) -> [TrackedElement] {
        trackedElements.values.filter(predicate)
    }
    
    /// Get all elements in a specific region
    public func elementsInRegion(_ region: CGRect) -> [TrackedElement] {
        trackedElements.values.filter { region.intersects($0.frame) }
    }
    
    /// Clear all tracked elements
    public func clearAll() {
        if Thread.isMainThread {
            trackedElements.removeAll()
            currentViewContext = nil
            viewContextMetadata.removeAll()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.trackedElements.removeAll()
                self?.currentViewContext = nil
                self?.viewContextMetadata.removeAll()
            }
        }
    }
    
    /// Get a snapshot of all current tracking data
    public func snapshot() -> TrackingSnapshot {
        TrackingSnapshot(
            elements: trackedElements,
            viewContext: currentViewContext,
            viewMetadata: viewContextMetadata,
            timestamp: Date()
        )
    }
    
    /// Debug print all tracked elements
    public func debugPrintAll() {
        #if DEBUG
        print("\n[AIAccess-Tracking] Current state:")
        print("  View: \(currentViewContext ?? "unknown")")
        print("  Elements: \(trackedElements.count)")
        for (id, element) in trackedElements.sorted(by: { $0.key < $1.key }) {
            print("    📍 \(id): (\(Int(element.center.x)), \(Int(element.center.y)))")
        }
        print("")
        #endif
    }
}

/// A snapshot of tracking data at a specific point in time
public struct TrackingSnapshot {
    public let elements: [String: CoordinateTracker.TrackedElement]
    public let viewContext: String?
    public let viewMetadata: [String: String]
    public let timestamp: Date
}