# SwiftAIAccess

**Make your iOS app AI-ready while improving accessibility for all users.**

## Origin Story

SwiftAIAccess was extracted from a production iOS app where I needed AI agents to efficiently navigate and test the application. While building the app, I discovered that AI tools like [ios-simulator-mcp](https://github.com/joshuayoes/ios-simulator-mcp) could interact with iOS simulators, but navigation via screenshots was slow and unreliable. 

By implementing structured accessibility identifiers and enhanced accessibility metadata, I enabled LLMs to navigate through the accessibility tree instead—resulting in **dramatically faster and more accurate automation**. What started as internal tooling became this comprehensive package that benefits both AI automation and traditional accessibility.

## About

SwiftAIAccess is a comprehensive Swift package that enables AI-powered navigation and automation in SwiftUI applications. It combines traditional accessibility best practices with AI-specific enhancements, creating apps that are discoverable and navigable by both assistive technologies and AI agents.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015%2B%20|%20macOS%2012%2B%20|%20tvOS%2015%2B%20|%20watchOS%208%2B-blue.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Why SwiftAIAccess?

As AI-powered development tools become mainstream, there's a growing need for apps that can be understood and navigated by AI agents. SwiftAIAccess solves this by:

- 🤖 **AI-Ready**: Makes your app discoverable by AI testing tools and automation frameworks
- ♿ **Accessible**: Enhances VoiceOver and accessibility features for all users
- 📊 **Analytics**: Provides structured interaction logging for user behavior analysis
- 🎯 **Precise**: Enables pixel-perfect AI navigation through coordinate tracking
- 🏗️ **Standardized**: Enforces consistent naming conventions across your app

## Quick Start

### Installation

#### Swift Package Manager

Add SwiftAIAccess to your project in Xcode:

1. Go to **File → Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/yourusername/SwiftAIAccess`
3. Select the version you want to use

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SwiftAIAccess", from: "1.0.0")
]
```

### Basic Usage

#### 1. Import the Framework

```swift
import SwiftAIAccess
```

#### 2. Make Your Components AI-Accessible

```swift
struct PrimaryButton: View, AIAccessible {
    let title: String
    let action: () -> Void
    
    // AIAccessible protocol properties
    var aiIdentifier: String?
    var aiLabel: String?
    var aiHint: String?
    var aiContext: [String: String] = [:]
    
    // Computed values for consistent naming
    var computedAIIdentifier: String {
        aiIdentifier ?? StandardIdentifiers.button("primary", title)
    }
    
    var computedAILabel: String {
        aiLabel ?? title
    }
    
    var computedAIHint: String {
        aiHint ?? "Activates \(title)"
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .applyAIAccess(self, interactionType: .button)
    }
}
```

#### 3. Track View Context

```swift
struct ContentView: View {
    var body: some View {
        VStack {
            PrimaryButton(title: "Get Started") {
                print("Button tapped!")
            }
        }
        .trackContext("ContentView")
    }
}
```

## Core Features

### 🎯 AI-Accessible Protocol

The `AIAccessible` protocol is the foundation of SwiftAIAccess. It standardizes how components expose themselves to AI agents:

```swift
protocol AIAccessible {
    var aiIdentifier: String? { get set }
    var aiLabel: String? { get set }
    var aiHint: String? { get set }
    var aiContext: [String: String] { get set }
    
    var computedAIIdentifier: String { get }
    var computedAILabel: String { get }
    var computedAIHint: String { get }
}
```

### 📍 Coordinate Tracking

SwiftAIAccess automatically tracks the position of UI elements, enabling precise AI navigation:

```swift
// Elements are automatically tracked when using applyAIAccess()
Text("Hello World")
    .trackElement("greeting_text")
    
// Access tracked elements
let element = CoordinateTracker.shared.findElement(identifier: "greeting_text")
print("Element center: \(element?.center ?? .zero)")
```

### 📝 Structured Logging

Built-in logging system that creates AI-parseable logs:

```swift
// Automatic interaction logging
AIAccessLogger.shared.logInteraction(
    identifier: "save_button",
    action: "tap",
    context: ["screen": "profile"]
)

// Custom events
AIAccessLogger.shared.logNavigation(
    from: "HomeView",
    to: "ProfileView",
    method: "button_tap"
)
```

### 🎮 Navigation Service

High-level API for AI automation and testing:

```swift
// Tap an element by identifier
NavigationService.shared.tapElement("save_button") { result in
    switch result {
    case .success:
        print("Element tapped successfully")
    case .elementNotFound(let id):
        print("Element not found: \(id)")
    case .timeout:
        print("Operation timed out")
    case .error(let error):
        print("Error: \(error)")
    }
}

// Wait for an element to appear
NavigationService.shared.waitForElement("loading_spinner", timeout: 5.0) { result in
    // Handle result
}
```

## Advanced Usage

### Custom Identifiers

Use the `StandardIdentifiers` helper for consistent naming:

```swift
struct FormField: View, AIAccessible {
    let label: String
    @Binding var text: String
    
    var computedAIIdentifier: String {
        StandardIdentifiers.textField(label, context: "user_profile")
        // Results in: "user_profile_textfield_email_address"
    }
    
    // ... rest of implementation
}
```

### Quick Extensions

For simple cases, use the provided view extensions:

```swift
Button("Save") { save() }
    .aiAccessButton(
        label: "Save changes",
        hint: "Saves all modifications to the profile"
    )
    
TextField("Email", text: $email)
    .aiAccessFormField(
        label: "Email address",
        hint: "Enter your email for account recovery"
    )
```

### Context Tracking

Track view hierarchy for better AI understanding:

```swift
NavigationView {
    VStack {
        // Content
    }
    .trackContext("ProfileView", metadata: [
        "user_id": user.id,
        "tab": "settings"
    ])
}
```

## Integration Examples

### With ios-simulator-mcp

SwiftAIAccess works exceptionally well with [ios-simulator-mcp](https://github.com/joshuayoes/ios-simulator-mcp), enabling LLMs to navigate iOS simulators through the accessibility tree rather than relying on slow screenshot analysis:

```python
# LLM can efficiently find and interact with elements by identifier
await simulator.tap_element("button_primary_save_changes")
await simulator.wait_for_element("modal_success_confirmation")

# Access structured element information
elements = await simulator.get_accessibility_tree()
# Returns: [{"identifier": "button_primary_save_changes", "label": "Save Changes", "frame": {...}}]
```

This approach is **10x faster** than screenshot-based navigation and provides reliable, precise element targeting for AI automation.

### With XCTest

```swift
func testButtonTap() {
    // Wait for element to appear
    NavigationService.shared.waitForElement("save_button") { result in
        XCTAssertEqual(result, .success)
    }
    
    // Tap the element
    NavigationService.shared.tapElement("save_button") { result in
        XCTAssertEqual(result, .success)
    }
    
    // Verify state change
    XCTAssertTrue(app.buttons["success_message"].exists)
}
```

### With Analytics

```swift
// Custom analytics integration
AIAccessLogger.shared.onInteraction = { identifier, action, context in
    Analytics.track("ui_interaction", properties: [
        "element": identifier,
        "action": action,
        "context": context
    ])
}
```

## Naming Conventions

SwiftAIAccess follows consistent naming patterns:

### Format
```
{category}_{context}_{element}_{modifier?}
```

### Categories
- `button_` - Interactive buttons
- `textfield_` - Input fields
- `navigation_` - Navigation elements
- `list_item_` - List items
- `card_` - Card components
- `toggle_` - Switches and toggles
- `tab_` - Tab bar items
- `modal_` - Modals and sheets

### Examples
```swift
"button_primary_save_changes"
"textfield_user_profile_email_address"
"navigation_tab_bar_settings"
"list_item_technique_brazilian_jiu_jitsu"
"card_dashboard_recent_activity"
```

## Configuration

### Disable in Production

```swift
#if DEBUG
AIAccessLogger.shared.isEnabled = true
CoordinateTracker.shared.isEnabled = true
#else
AIAccessLogger.shared.isEnabled = false
CoordinateTracker.shared.isEnabled = false
#endif
```

### Custom Log Categories

```swift
AIAccessLogger.shared.logLevel = .debug
```

## Best Practices

1. **Always provide meaningful labels and hints**
   ```swift
   .accessibilityLabel("Save profile changes")
   .accessibilityHint("Validates and stores all profile modifications")
   ```

2. **Use consistent identifier patterns**
   ```swift
   StandardIdentifiers.button("primary", "Save Changes")
   // → "button_primary_save_changes"
   ```

3. **Track view context for navigation flows**
   ```swift
   .trackContext("ProfileEditView")
   ```

4. **Provide context for complex interactions**
   ```swift
   .aiContext(["screen": "profile", "section": "personal_info"])
   ```

5. **Test with both VoiceOver and AI tools**

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Swift 5.9+
- SwiftUI

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

SwiftAIAccess is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Roadmap

- [ ] UIKit support
- [ ] Automatic screenshot generation for AI training
- [ ] Integration with popular testing frameworks
- [ ] Visual element recognition
- [ ] Voice command integration
- [ ] Gesture recording and playback

---

**Made with ❤️ for the AI-powered future of iOS development**