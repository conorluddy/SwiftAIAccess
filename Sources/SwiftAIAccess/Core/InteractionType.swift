import SwiftUI

/// Defines the types of interactions a component supports.
/// This helps AI agents understand how to interact with different UI elements.
public enum AIAccessInteractionType: String, CaseIterable {
    /// Interactive button that performs an action
    case button
    
    /// Navigation element that changes the view
    case navigation
    
    /// Input field for text or data entry
    case input
    
    /// Display-only element for information
    case display
    
    /// Container element that groups other elements
    case container
    
    /// Toggle switch or checkbox
    case toggle
    
    /// Selectable item in a list or collection
    case selection
    
    /// Draggable or reorderable element
    case draggable
    
    /// Returns appropriate accessibility traits for the interaction type
    public var accessibilityTraits: AccessibilityTraits {
        switch self {
        case .button, .navigation:
            return .isButton
        case .toggle:
            return [.isButton]
        case .selection:
            return [.isButton, .isSelected]
        default:
            return []
        }
    }
    
    /// Human-readable description of the interaction type
    public var description: String {
        switch self {
        case .button: return "Button"
        case .navigation: return "Navigation"
        case .input: return "Input Field"
        case .display: return "Display"
        case .container: return "Container"
        case .toggle: return "Toggle"
        case .selection: return "Selection"
        case .draggable: return "Draggable"
        }
    }
}