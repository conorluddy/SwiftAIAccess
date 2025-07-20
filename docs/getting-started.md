# Getting Started with SwiftAIAccess

This guide will walk you through implementing SwiftAIAccess in your iOS app, whether you're starting a new project or adding it to an existing one.

## Table of Contents

- [Quick Start (5 Minutes)](#quick-start)
- [New Project Implementation](#new-project)
- [Understanding the Core Concepts](#core-concepts)
- [Implementation Approaches](#implementation-approaches)
- [Common Patterns](#common-patterns)
- [Troubleshooting](#troubleshooting)

## Quick Start

Get SwiftAIAccess working in your app in 5 minutes with the extension-based approach.

### 1. Installation

Add SwiftAIAccess to your Xcode project:

**File → Add Package Dependencies...**
```
https://github.com/conorluddy/SwiftAIAccess
```

### 2. Import and Basic Usage

```swift
import SwiftAIAccess

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .aiAccessFormField(
                    label: "Email address",
                    hint: "Enter your email for login"
                )
            
            SecureField("Password", text: $password)
                .aiAccessFormField(
                    label: "Password",
                    hint: "Enter your account password"
                )
            
            Button("Login") { 
                // Login logic
            }
            .aiAccessButton(
                label: "Log into account",
                hint: "Authenticates with email and password"
            )
        }
        .trackContext("LoginView") // Tell AI agents about current screen
        .padding()
    }
}
```

### 3. Verify Integration

Run your app and check that elements have proper accessibility identifiers:

```swift
// In your tests or debug console
print(CoordinateTracker.shared.trackedElements.keys)
// Should output: ["textfield_email_address", "textfield_password", "button_log_into_account"]
```

**🎉 Congratulations!** Your app is now AI-ready. AI agents can reliably find and interact with your UI elements.

## New Project

Starting a new project? Follow this approach to build AI-first from day one.

### Project Setup

1. **Create new iOS project** in Xcode
2. **Add SwiftAIAccess** as a dependency
3. **Set up your base architecture** with AI accessibility in mind

### Recommended Project Structure

```
MyApp/
├── Views/
│   ├── Components/     # Reusable UI components (all AIAccessible)
│   ├── Screens/        # Screen-level views with context tracking
│   └── Navigation/     # Navigation helpers
├── Models/
├── Services/
└── Resources/
```

### Base Component Example

Create reusable, AI-accessible components:

```swift
import SwiftAIAccess

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
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
        .applyAIAccess(self, interactionType: .button)
    }
}
```

### Screen-Level Implementation

```swift
struct LoginScreen: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 24) {
            AppTextField(
                placeholder: "Email",
                text: $email,
                identifier: "email_input"
            )
            
            AppTextField(
                placeholder: "Password",
                text: $password,
                isSecure: true,
                identifier: "password_input"
            )
            
            PrimaryButton(title: "Login") {
                login()
            }
            
            if isLoading {
                ProgressView("Logging in...")
                    .trackElement("loading_indicator")
            }
        }
        .trackContext("LoginScreen", metadata: [
            "user_type": "returning",
            "auth_method": "email"
        ])
        .padding()
    }
    
    private func login() {
        isLoading = true
        // Login implementation
    }
}
```

## Core Concepts

Understanding these concepts will help you implement SwiftAIAccess effectively.

### 1. AI-Accessible Protocol

The foundation of SwiftAIAccess. Makes your components discoverable by AI agents:

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

**Key Points:**
- **aiIdentifier**: Optional custom identifier (uses StandardIdentifiers if nil)
- **aiLabel**: Human-readable description of the element
- **aiHint**: What happens when the element is activated
- **aiContext**: Additional metadata for AI understanding

### 2. Standard Identifiers

Consistent naming convention across your app:

```swift
// Format: {category}_{context}_{element}_{modifier?}

StandardIdentifiers.button("primary", "Save Changes")
// → "button_primary_save_changes"

StandardIdentifiers.textField("Email Address", context: "login")
// → "login_textfield_email_address"

StandardIdentifiers.navigation("Settings")
// → "navigation_settings"
```

**Categories:**
- `button_` - Interactive buttons
- `textfield_` - Input fields
- `navigation_` - Navigation elements
- `list_item_` - List items
- `card_` - Card components
- `toggle_` - Switches and toggles
- `tab_` - Tab bar items
- `modal_` - Modals and sheets

### 3. Coordinate Tracking

Automatic tracking of UI element positions for precise AI navigation:

```swift
// Elements are automatically tracked when using applyAIAccess()
Text("Hello World")
    .trackElement("greeting_text")
    
// Access tracked elements
let element = CoordinateTracker.shared.findElement(identifier: "greeting_text")
print("Element center: \(element?.center ?? .zero)")
```

### 4. Context Tracking

Tell AI agents about the current screen and navigation state:

```swift
struct ProfileView: View {
    let user: User
    
    var body: some View {
        VStack {
            // Profile content
        }
        .trackContext("ProfileView", metadata: [
            "user_id": user.id,
            "user_type": user.type,
            "screen_variant": "edit_mode"
        ])
    }
}
```

## Implementation Approaches

Choose the approach that best fits your needs and constraints.

### Approach 1: View Extensions (Fastest)

Perfect for quick integration or retrofitting existing apps:

```swift
import SwiftAIAccess

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

**Pros:**
- ✅ Fastest implementation
- ✅ No structural changes needed
- ✅ Perfect for retrofitting

**Cons:**
- ❌ Less flexible
- ❌ Harder to customize identifiers
- ❌ Can't leverage full protocol features

### Approach 2: Protocol Implementation (Recommended)

Best for new projects or when you want full control:

```swift
struct CustomButton: View, AIAccessible {
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
    // AIAccessible implementation
    var aiIdentifier: String?
    var aiLabel: String?
    var aiHint: String?
    var aiContext: [String: String] = [:]
    
    var computedAIIdentifier: String {
        aiIdentifier ?? StandardIdentifiers.button(style.rawValue, title)
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
                .buttonStyle(style)
        }
        .applyAIAccess(self, interactionType: .button)
    }
}
```

**Pros:**
- ✅ Full flexibility and control
- ✅ Reusable components
- ✅ Custom identifier logic
- ✅ Rich context support

**Cons:**
- ❌ More initial setup
- ❌ Requires understanding protocol

### Approach 3: Hybrid (Balanced)

Use protocols for reusable components, extensions for one-offs:

```swift
// Reusable component with protocol
struct AppButton: View, AIAccessible {
    // Full implementation
}

// One-off usage with extension
Text("Temporary notice")
    .aiAccessElement(
        identifier: "temp_notice",
        label: "Important notice",
        hint: "Displays temporary information"
    )
```

## Common Patterns

### Form Implementation

```swift
struct RegistrationForm: View, AIAccessible {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // AIAccessible implementation
    var computedAIIdentifier: String {
        StandardIdentifiers.form("registration")
    }
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .aiAccessFormField(
                    label: "Email address",
                    hint: "Enter your email for account creation"
                )
            
            SecureField("Password", text: $password)
                .aiAccessFormField(
                    label: "Password",
                    hint: "Choose a secure password"
                )
            
            SecureField("Confirm Password", text: $confirmPassword)
                .aiAccessFormField(
                    label: "Confirm password",
                    hint: "Re-enter your password to confirm"
                )
            
            Button("Create Account") {
                createAccount()
            }
            .aiAccessButton(
                label: "Create account",
                hint: "Submits registration form"
            )
        }
        .applyAIAccess(self, interactionType: .container)
        .trackContext("RegistrationForm", metadata: [
            "form_type": "user_registration",
            "step": "account_creation"
        ])
    }
}
```

### List Implementation

```swift
struct UserList: View {
    let users: [User]
    
    var body: some View {
        List(users.indices, id: \\.self) { index in
            UserRow(user: users[index])
                .trackElement(
                    StandardIdentifiers.listItem("user", index: index),
                    context: ["user_id": users[index].id]
                )
        }
        .trackContext("UserList", metadata: [
            "total_users": "\(users.count)",
            "list_type": "user_directory"
        ])
    }
}

struct UserRow: View, AIAccessible {
    let user: User
    
    var computedAIIdentifier: String {
        StandardIdentifiers.listItem("user_\(user.id)")
    }
    
    var computedAILabel: String {
        "\(user.name), \(user.role)"
    }
    
    var computedAIHint: String {
        "View \(user.name)'s profile"
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: user.avatarURL)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.role)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .applyAIAccess(self, interactionType: .selection)
    }
}
```

### Navigation Implementation

```swift
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
                .trackElement("tab_home")
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(1)
                .trackElement("tab_profile")
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
                .trackElement("tab_settings")
        }
        .trackContext("MainTabView", metadata: [
            "selected_tab": "\(selectedTab)",
            "navigation_type": "tab_based"
        ])
    }
}
```

## Configuration and Optimization

### Debug vs Production

Configure SwiftAIAccess behavior based on build configuration:

```swift
// In your App.swift or SceneDelegate
#if DEBUG
AIAccessLogger.shared.isEnabled = true
CoordinateTracker.shared.isEnabled = true
AIAccessLogger.shared.logLevel = .debug
#else
AIAccessLogger.shared.isEnabled = false
CoordinateTracker.shared.isEnabled = true // Keep for automation
AIAccessLogger.shared.logLevel = .error
#endif
```

### Custom Logging Integration

```swift
// Integrate with your analytics system
AIAccessLogger.shared.onInteraction = { identifier, action, context in
    Analytics.track("ui_interaction", properties: [
        "element": identifier,
        "action": action,
        "context": context,
        "timestamp": Date().timeIntervalSince1970
    ])
}

AIAccessLogger.shared.onNavigation = { from, to, method in
    Analytics.track("screen_navigation", properties: [
        "from": from ?? "unknown",
        "to": to,
        "method": method,
        "timestamp": Date().timeIntervalSince1970
    ])
}
```

### Performance Optimization

```swift
// Batch coordinate updates for better performance
CoordinateTracker.shared.setBatchUpdateMode(true)

// Clean up stale elements periodically
Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
    CoordinateTracker.shared.removeElementsOlderThan(60.0)
}
```

## Troubleshooting

### Common Issues

**Q: Elements aren't being tracked**
```swift
// ❌ Wrong: Missing applyAIAccess
Button("Test") { }

// ✅ Correct: Include modifier
Button("Test") { }
    .aiAccessButton(label: "Test button")
```

**Q: Identifiers are inconsistent**
```swift
// ❌ Wrong: Manual identifier strings
.trackElement("saveBtn")
.trackElement("save_button")

// ✅ Correct: Use StandardIdentifiers
.trackElement(StandardIdentifiers.button("save"))
```

**Q: AI can't find elements reliably**
```swift
// ❌ Wrong: Vague or missing labels
.aiAccessButton(label: "Button")

// ✅ Correct: Descriptive labels and hints
.aiAccessButton(
    label: "Save profile changes",
    hint: "Validates and saves all profile modifications"
)
```

**Q: App performance issues**
```swift
// ❌ Wrong: Tracking too many elements
ForEach(thousands_of_items) { item in
    Text(item.name).trackElement("item_\(item.id)")
}

// ✅ Correct: Track only interactive elements
ForEach(items) { item in
    Button(item.name) { select(item) }
        .aiAccessButton(label: item.name)
}
```

### Debugging Tools

```swift
// Print all tracked elements
CoordinateTracker.shared.debugPrintAll()

// Check element tracking in real-time
NavigationService.shared.getAllElements().forEach { identifier, element in
    print("\(identifier): \(element.center)")
}

// Validate integration
func validateSwiftAIAccessIntegration() {
    let elements = CoordinateTracker.shared.trackedElements
    let issues = elements.compactMap { identifier, element -> String? in
        if identifier.isEmpty {
            return "Empty identifier found"
        }
        if element.frame.isEmpty {
            return "Empty frame for \(identifier)"
        }
        return nil
    }
    
    if issues.isEmpty {
        print("✅ SwiftAIAccess integration looks good!")
    } else {
        print("⚠️ Issues found: \(issues)")
    }
}
```

## Next Steps

- **[Migration Guide](migration-guide.md)** - Add SwiftAIAccess to existing projects
- **[Implementation Patterns](implementation-patterns.md)** - Real-world examples and best practices
- **[AI Integration](ai-integration.md)** - Working with automation tools like ios-simulator-mcp
- **[LLM Prompts](../prompts/)** - Templates for AI agents to help with implementation

## Need Help?

- **🐛 Found a bug?** [Report it on GitHub](https://github.com/conorluddy/SwiftAIAccess/issues)
- **💬 Have questions?** [Start a discussion](https://github.com/conorluddy/SwiftAIAccess/discussions)
- **📖 Want to contribute?** Check our [Contributing Guide](../CONTRIBUTING.md)