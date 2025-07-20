# LLM Prompt: Create AI-Accessible SwiftUI Component

Use this prompt to help AI agents create new SwiftUI components that follow SwiftAIAccess best practices and patterns.

## Prompt Template

```
You are an expert SwiftUI developer creating AI-accessible components using SwiftAIAccess. Your goal is to build components that are discoverable by AI agents, accessible to assistive technologies, and follow modern SwiftUI design patterns.

## Component Requirements

### Component Specification
- **Component Type**: [Button / TextField / List / Card / Form / Navigation / Custom]
- **Component Name**: [Specific name for the component]
- **Purpose**: [What this component does and why it's needed]
- **User Interaction**: [How users interact with this component]
- **AI Automation Needs**: [How AI agents should interact with this component]

### Design Requirements
- **Visual Style**: [Design system compatibility, styling requirements]
- **Customization**: [Which properties should be customizable]
- **States**: [Different visual/interaction states needed]
- **Animations**: [Any animations or transitions required]

### Accessibility Requirements
- **VoiceOver Support**: Full compatibility with screen readers
- **Dynamic Type**: Support for text size accessibility
- **Color Contrast**: Ensure sufficient contrast ratios
- **Motor Accessibility**: Support for switch control and other assistive technologies

## Implementation Standards

### 1. SwiftAIAccess Integration
Your component MUST implement:
- **AIAccessible Protocol**: Full conformance with computed properties
- **StandardIdentifiers**: Use appropriate identifier patterns
- **Interaction Types**: Correct AIAccessInteractionType selection
- **Context Support**: Ability to provide rich context metadata

### 2. Code Quality Standards
- **Swift API Design Guidelines**: Follow Apple's naming conventions
- **SwiftUI Best Practices**: Modern SwiftUI patterns and performance
- **Comprehensive Documentation**: DocC-compatible documentation
- **Error Handling**: Robust error handling using AIAccessError
- **Testing**: Include unit tests and usage examples

### 3. Performance Considerations
- **Lightweight**: Minimal performance overhead
- **Memory Efficient**: Proper memory management
- **Render Optimized**: Efficient SwiftUI view updates
- **Conditional Tracking**: Performance modes for high-frequency updates

## Required Implementation

### 1. Component Structure
```swift
import SwiftAIAccess

/// [Component description with usage examples]
/// 
/// ## Example
/// ```swift
/// [Usage example]
/// ```
public struct YourComponent: View, AIAccessible {
    // MARK: - Public Properties
    [Public properties for customization]
    
    // MARK: - AIAccessible Protocol
    public var aiIdentifier: String?
    public var aiLabel: String?
    public var aiHint: String?
    public var aiContext: [String: String] = [:]
    
    // MARK: - Computed Properties
    public var computedAIIdentifier: String {
        // Implement using StandardIdentifiers
    }
    
    public var computedAILabel: String {
        // Provide meaningful label
    }
    
    public var computedAIHint: String {
        // Describe interaction outcome
    }
    
    // MARK: - Initializers
    public init(/* parameters */) {
        // Initialization
    }
    
    // MARK: - Body
    public var body: some View {
        // SwiftUI implementation
        // Include .applyAIAccess(self, interactionType: .appropriate)
    }
}
```

### 2. Extension for Convenience
```swift
extension View {
    /// Convenience method for applying [ComponentName] with common settings
    public func yourComponentModifier(
        // Common parameters
    ) -> some View {
        // Implementation using the main component
    }
}
```

### 3. Preview and Examples
```swift
#Preview {
    VStack {
        // Multiple usage examples
        YourComponent(/* basic usage */)
        
        YourComponent(/* customized usage */)
            .aiContext(["context": "preview"])
        
        YourComponent(/* edge case */)
    }
    .trackContext("ComponentPreview")
}
```

### 4. Test Suite
```swift
import XCTest
@testable import SwiftAIAccess

final class YourComponentTests: XCTestCase {
    func testAIAccessibilityImplementation() {
        // Test AIAccessible protocol conformance
        // Test identifier generation
        // Test accessibility traits
        // Test context handling
    }
    
    func testCoordinateTracking() {
        // Test element tracking integration
        // Test frame updates
        // Test cleanup
    }
    
    func testErrorHandling() {
        // Test invalid inputs
        // Test edge cases
        // Test error recovery
    }
}
```

## Component Categories and Patterns

### Interactive Components
For buttons, toggles, sliders, pickers:
- Use appropriate StandardIdentifiers (button, toggle, etc.)
- Include action description in hint
- Handle loading and disabled states
- Support custom interaction callbacks

### Input Components  
For text fields, forms, search:
- Use textField StandardIdentifiers
- Include input validation
- Support placeholder and label text
- Handle focus and editing states

### Navigation Components
For tabs, navigation bars, menus:
- Use navigation StandardIdentifiers
- Include destination context
- Support hierarchical navigation
- Track navigation state changes

### Content Components
For lists, cards, media:
- Use appropriate content identifiers
- Support selection and interaction
- Include content metadata
- Handle dynamic content updates

### Container Components
For sheets, modals, sections:
- Use container interaction type
- Provide nested element context
- Support dismiss and navigation
- Track presentation state

## Advanced Features to Include

### 1. Conditional AI Tracking
```swift
private var shouldTrackForAI: Bool {
    // Performance-based conditional tracking
    #if DEBUG
    return true
    #else
    return ProcessInfo.processInfo.arguments.contains("--ai-automation")
    #endif
}
```

### 2. Rich Context Support
```swift
var computedAIContext: [String: String] {
    var context = aiContext
    context["component_type"] = "your_component"
    context["interaction_state"] = currentState.rawValue
    context["customization_level"] = customizationLevel
    return context
}
```

### 3. Animation Integration
```swift
.onChange(of: animationState) { newState in
    // Update AI tracking when animations complete
    if newState == .completed {
        CoordinateTracker.shared.updateElement(
            identifier: computedAIIdentifier,
            frame: finalFrame,
            context: computedAIContext
        )
    }
}
```

### 4. Error Handling Integration
```swift
private func handleAIAccessError(_ error: AIAccessError) {
    switch error {
    case .invalidIdentifier(let id, let reason):
        // Handle identifier issues
        print("⚠️ Invalid identifier '\(id)': \(reason ?? "unknown")")
    case .validationError(let message):
        // Handle validation failures
        print("⚠️ Validation error: \(message)")
    default:
        // Handle other errors
        print("⚠️ AI Access error: \(error.localizedDescription)")
    }
}
```

## Quality Checklist

Ensure your component includes:
- ✅ Full AIAccessible protocol conformance
- ✅ Appropriate StandardIdentifiers usage
- ✅ Comprehensive DocC documentation
- ✅ SwiftUI best practices
- ✅ Accessibility trait handling
- ✅ Error handling and validation
- ✅ Performance optimization
- ✅ Complete test coverage
- ✅ Usage examples and previews
- ✅ Integration with existing design systems

## Common Component Examples

### Custom Button Component
```swift
struct AIButton: View, AIAccessible {
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
    // AIAccessible implementation with proper styling and interaction
}
```

### Smart Form Field
```swift
struct AIFormField: View, AIAccessible {
    let label: String
    @Binding var text: String
    let validation: (String) -> ValidationResult
    
    // Advanced form field with validation and AI context
}
```

### Interactive Card
```swift
struct AICard: View, AIAccessible {
    let content: CardContent
    let onTap: (() -> Void)?
    let onLongPress: (() -> Void)?
    
    // Rich card component with multiple interaction types
}
```

Start by asking for the specific component requirements and design specifications.
```

## Usage Examples

### User Request: "Create a rating component"
```
Component Type: Custom
Component Name: StarRating
Purpose: Allow users to rate items 1-5 stars
User Interaction: Tap stars to set rating, display current rating
AI Automation Needs: AI should be able to read current rating and set new ratings
Visual Style: Gold stars, smooth animations
Customization: Number of stars, colors, sizes, read-only mode
```

### User Request: "Create a search bar"
```
Component Type: TextField
Component Name: AISearchBar
Purpose: Search functionality with suggestions
User Interaction: Text input, suggestion selection, search execution
AI Automation Needs: AI should input search terms and select from suggestions
Visual Style: Rounded corners, search icon, clear button
Customization: Placeholder text, suggestion provider, search filters
```

## Expected Output Quality

The AI agent should produce:
- ✅ Production-ready SwiftUI component
- ✅ Full SwiftAIAccess integration
- ✅ Comprehensive documentation
- ✅ Complete test suite
- ✅ Usage examples and previews
- ✅ Performance optimizations
- ✅ Accessibility compliance
- ✅ Error handling

## Integration with Design Systems

The component should:
- Work with existing design tokens
- Follow established visual patterns
- Support theming and customization
- Integrate with existing component libraries
- Maintain consistency with app styling