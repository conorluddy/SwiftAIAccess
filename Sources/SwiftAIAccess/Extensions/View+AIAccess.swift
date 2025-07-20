import SwiftUI

/// SwiftUI View extensions for easy AIAccess integration
public extension View {
    
    /// Apply AIAccess integration using an AIAccessible component
    /// - Parameters:
    ///   - accessible: Component conforming to AIAccessible
    ///   - componentType: Description of the component type
    ///   - interactionType: Type of interaction this component supports
    ///   - enableLogging: Whether to enable interaction logging
    ///   - enableTracking: Whether to enable coordinate tracking
    /// - Returns: Modified view with AIAccess integration
    func applyAIAccess(
        _ accessible: AIAccessible,
        componentType: String = "Component",
        interactionType: AIAccessInteractionType = .button,
        enableLogging: Bool = true,
        enableTracking: Bool = true
    ) -> some View {
        modifier(
            AIAccessModifier(
                accessible: accessible,
                componentType: componentType,
                interactionType: interactionType,
                enableLogging: enableLogging,
                enableTracking: enableTracking
            )
        )
    }
    
    /// Quick AIAccess setup for buttons
    /// - Parameters:
    ///   - identifier: Unique identifier (uses StandardIdentifiers.button if nil)
    ///   - label: Accessibility label
    ///   - hint: Accessibility hint
    ///   - context: Additional context
    /// - Returns: Modified view with button AIAccess
    func aiAccessButton(
        identifier: String? = nil,
        label: String,
        hint: String? = nil,
        context: [String: String] = [:]
    ) -> some View {
        self
            .accessibilityIdentifier(identifier ?? StandardIdentifiers.button("default", label))
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "Activates \(label)")
            .accessibilityAddTraits(.isButton)
            .background(
                AIAccessTrackingView(
                    identifier: identifier ?? StandardIdentifiers.button("default", label),
                    context: context
                )
            )
    }
    
    /// Quick AIAccess setup for navigation items
    /// - Parameters:
    ///   - identifier: Unique identifier
    ///   - destination: Navigation destination
    ///   - hint: Accessibility hint
    ///   - context: Additional context
    /// - Returns: Modified view with navigation AIAccess
    func aiAccessNavigation(
        identifier: String? = nil,
        destination: String,
        hint: String? = nil,
        context: [String: String] = [:]
    ) -> some View {
        self
            .accessibilityIdentifier(identifier ?? StandardIdentifiers.navigation(destination))
            .accessibilityLabel("Navigate to \(destination)")
            .accessibilityHint(hint ?? "Opens \(destination)")
            .accessibilityAddTraits(.isButton)
            .background(
                AIAccessTrackingView(
                    identifier: identifier ?? StandardIdentifiers.navigation(destination),
                    context: context
                )
            )
    }
    
    /// Quick AIAccess setup for form fields
    /// - Parameters:
    ///   - identifier: Unique identifier
    ///   - label: Field label
    ///   - hint: Accessibility hint
    ///   - context: Additional context
    /// - Returns: Modified view with form field AIAccess
    func aiAccessFormField(
        identifier: String? = nil,
        label: String,
        hint: String? = nil,
        context: [String: String] = [:]
    ) -> some View {
        self
            .accessibilityIdentifier(identifier ?? StandardIdentifiers.textField(label))
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "Enter \(label)")
            .background(
                AIAccessTrackingView(
                    identifier: identifier ?? StandardIdentifiers.textField(label),
                    context: context
                )
            )
    }
    
    /// Quick AIAccess setup for list items
    /// - Parameters:
    ///   - identifier: Unique identifier
    ///   - title: Item title
    ///   - index: Item index in list
    ///   - hint: Accessibility hint
    ///   - context: Additional context
    /// - Returns: Modified view with list item AIAccess
    func aiAccessListItem(
        identifier: String? = nil,
        title: String,
        index: Int? = nil,
        hint: String? = nil,
        context: [String: String] = [:]
    ) -> some View {
        self
            .accessibilityIdentifier(identifier ?? StandardIdentifiers.listItem(title, index: index))
            .accessibilityLabel(title)
            .accessibilityHint(hint ?? "Select \(title)")
            .accessibilityAddTraits(.isButton)
            .background(
                AIAccessTrackingView(
                    identifier: identifier ?? StandardIdentifiers.listItem(title, index: index),
                    context: context
                )
            )
    }
    
    /// Track this element's coordinates without full AIAccess integration
    /// - Parameters:
    ///   - identifier: Element identifier
    ///   - context: Additional context
    /// - Returns: Modified view with coordinate tracking
    func trackElement(
        _ identifier: String,
        context: [String: String] = [:]
    ) -> some View {
        background(
            AIAccessTrackingView(
                identifier: identifier,
                context: context
            )
        )
    }
    
    /// Set the current view context for AI navigation
    /// - Parameters:
    ///   - name: View name
    ///   - metadata: Additional metadata about the view
    /// - Returns: Modified view with context tracking
    func trackContext(
        _ name: String,
        metadata: [String: String] = [:]
    ) -> some View {
        onAppear {
            CoordinateTracker.shared.updateViewContext(
                name: name,
                metadata: metadata
            )
        }
    }
}

/// Internal view for coordinate tracking
private struct AIAccessTrackingView: View {
    let identifier: String
    let context: [String: String]
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    updateTracking(geometry: geometry)
                }
                .onChange(of: geometry.frame(in: .global)) { _ in
                    updateTracking(geometry: geometry)
                }
                .onDisappear {
                    CoordinateTracker.shared.removeElement(identifier: identifier)
                }
        }
    }
    
    private func updateTracking(geometry: GeometryProxy) {
        CoordinateTracker.shared.updateElement(
            identifier: identifier,
            frame: geometry.frame(in: .global),
            context: context
        )
    }
}