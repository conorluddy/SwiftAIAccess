import SwiftUI

/// A protocol that standardizes AI-powered accessibility integration for SwiftUI components.
///
/// Conforming to this protocol ensures your components are discoverable and navigable by AI agents,
/// automated testing tools, and assistive technologies.
///
/// ## Example Implementation
/// ```swift
/// struct MyButton: View, AIAccessible {
///     let title: String
///     let action: () -> Void
///
///     // AIAccess properties
///     var aiIdentifier: String?
///     var aiLabel: String?
///     var aiHint: String?
///     var aiContext: [String: String] = [:]
///
///     // Computed values
///     var computedAIIdentifier: String {
///         aiIdentifier ?? "button_\(title.lowercased())"
///     }
///
///     var computedAILabel: String {
///         aiLabel ?? title
///     }
///
///     var computedAIHint: String {
///         aiHint ?? "Activates \(title)"
///     }
///
///     var body: some View {
///         Button(action: action) {
///             Text(title)
///         }
///         .applyAIAccess(self)
///     }
/// }
/// ```
public protocol AIAccessible {
    // MARK: - Required AIAccess Properties
    
    /// Unique identifier for AI navigation.
    /// If nil, component should generate a default identifier.
    var aiIdentifier: String? { get set }
    
    /// Optional accessibility label override.
    /// Uses component's primary text if not provided.
    var aiLabel: String? { get set }
    
    /// Optional accessibility hint for action guidance.
    var aiHint: String? { get set }
    
    /// Optional context metadata for AI understanding.
    var aiContext: [String: String] { get set }
    
    // MARK: - Computed AIAccess Values
    
    /// Computed identifier following naming conventions.
    /// Should follow pattern: `{category}_{context}_{element}_{modifier?}`
    var computedAIIdentifier: String { get }
    
    /// Computed label for accessibility.
    var computedAILabel: String { get }
    
    /// Computed hint for accessibility.
    var computedAIHint: String { get }
}