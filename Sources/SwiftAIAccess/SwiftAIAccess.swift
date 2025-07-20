/// SwiftAIAccess - Make your iOS app AI-ready
///
/// A comprehensive framework for adding AI-powered accessibility and navigation
/// to SwiftUI applications, while improving accessibility for all users.
///
/// ## Quick Start
///
/// ```swift
/// import SwiftAIAccess
///
/// struct MyButton: View, AIAccessible {
///     let title: String
///     let action: () -> Void
///     
///     // AIAccessible properties
///     var aiIdentifier: String?
///     var aiLabel: String?
///     var aiHint: String?
///     var aiContext: [String: String] = [:]
///     
///     // Computed values
///     var computedAIIdentifier: String {
///         aiIdentifier ?? StandardIdentifiers.button("primary", title)
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

// Re-export all public APIs for convenience
@_exported import Foundation
@_exported import SwiftUI
