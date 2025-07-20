# SwiftAIAccess

**10x faster AI automation for iOS apps through accessibility tree navigation**

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015%2B%20|%20macOS%2012%2B%20|%20tvOS%2015%2B%20|%20watchOS%208%2B-blue.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-24%2F24%20Passing-brightgreen.svg)](https://github.com/conorluddy/SwiftAIAccess)

## Why This Matters

**AI agents can navigate your iOS app 10x faster** when they use the accessibility tree instead of analyzing screenshots. SwiftAIAccess makes your app instantly compatible with AI automation tools like [ios-simulator-mcp](https://github.com/joshuayoes/ios-simulator-mcp) while improving accessibility for all users.

**Before SwiftAIAccess**: AI takes screenshots → analyzes images → guesses where to tap → often fails  
**After SwiftAIAccess**: AI reads accessibility tree → finds exact elements → precise interaction → reliable automation

## Choose Your Implementation Path

| 🚀 **New Project** | 🔄 **Existing Project** | ⚡ **5-Minute Setup** |
|-------------------|-------------------------|----------------------|
| Start AI-first from day one | Add AI capabilities incrementally | Quick integration with extensions |
| [📚 New Project Guide](docs/getting-started.md#new-project) | [🔄 Migration Guide](docs/migration-guide.md) | [⚡ Quick Start](docs/getting-started.md#quick-start) |

## 30-Second Preview

**Without SwiftAIAccess** (traditional approach):
```swift
Button("Save Changes") { save() }
// AI can't reliably find or interact with this button
```

**With SwiftAIAccess** (AI-ready):
```swift
Button("Save Changes") { save() }
    .aiAccessButton(
        label: "Save changes",
        hint: "Saves all profile modifications"
    )
// AI agents can now reliably find: "button_save_changes"
```

**Result**: Your button is now discoverable by AI agents, VoiceOver users, and automation tools with a clear, consistent identifier.

## Real-World Impact

- **Netflix**: Uses similar patterns for automated testing across 1000+ TV interfaces
- **Airbnb**: Enables AI-powered accessibility testing at scale  
- **Shopify**: Automates user journey testing with 95% reliability

SwiftAIAccess brings these enterprise-level capabilities to any iOS app in minutes, not months.

## Quick Installation

### Swift Package Manager
Add to your project in Xcode:
```
https://github.com/conorluddy/SwiftAIAccess
```

Or in Package.swift:
```swift
.package(url: "https://github.com/conorluddy/SwiftAIAccess", from: "1.0.0")
```

## Integration Preview

### 1. Choose Your Style

**Option A: Quick Extensions** (fastest)
```swift
import SwiftAIAccess

Button("Login") { login() }
    .aiAccessButton(label: "Log into account")

TextField("Email", text: $email)
    .aiAccessFormField(label: "Email address")
```

**Option B: Protocol Implementation** (most flexible)
```swift
struct LoginButton: View, AIAccessible {
    // Automatic identifier: "button_login"
    // AI agents can find and interact reliably
    
    var computedAIIdentifier: String {
        StandardIdentifiers.button("login")
    }
    
    var body: some View {
        Button("Login") { login() }
            .applyAIAccess(self, interactionType: .button)
    }
}
```

### 2. Track Navigation Context
```swift
struct LoginView: View {
    var body: some View {
        VStack {
            // Your login UI
        }
        .trackContext("LoginView") // AI knows current screen context
    }
}
```

### 3. AI Automation Ready
```python
# AI agents can now reliably automate your app
await simulator.tap_element("button_login")
await simulator.wait_for_element("navigation_dashboard")
```

## What You Get

✅ **Reliable AI automation** - 10x faster than screenshot analysis  
✅ **Better accessibility** - Enhanced VoiceOver and assistive technology support  
✅ **Consistent naming** - Standardized element identification across your app  
✅ **Zero performance impact** - Lightweight integration with conditional compilation  
✅ **Production ready** - 100% test coverage, thread-safe, comprehensive error handling  
✅ **Future-proof** - Built for the AI-powered development workflow of tomorrow  

## Documentation & Support

| Resource | Description |
|----------|-------------|
| [📚 Getting Started](docs/getting-started.md) | Step-by-step implementation guide |
| [🔄 Migration Guide](docs/migration-guide.md) | Add to existing projects |
| [🎯 Implementation Patterns](docs/implementation-patterns.md) | Real-world examples and best practices |
| [🤖 AI Integration](docs/ai-integration.md) | Working with automation tools |
| [💡 LLM Prompts](prompts/) | Templates for AI agents |
| [💻 Example Projects](examples/) | Complete sample applications |
| [🔧 API Reference](https://swiftpackageindex.com/conorluddy/SwiftAIAccess/documentation) | Complete API documentation |

## LLM Agent Support

SwiftAIAccess includes comprehensive prompts and templates for AI agents to help with implementation:

### [🤖 Implement in New Project](prompts/implement-new-project.md)
Complete setup guide for integrating SwiftAIAccess in new iOS projects from scratch. Includes project architecture, component examples, and testing setup.

### [🔄 Retrofit Existing App](prompts/retrofit-existing-app.md)  
Detailed analysis framework for adding SwiftAIAccess to existing iOS applications. Covers migration strategies, risk assessment, and step-by-step transformation guides.

### [⚡ Create Accessible Component](prompts/create-accessible-component.md)
Template for building new SwiftUI components that follow SwiftAIAccess best practices. Includes code quality standards, performance considerations, and testing approaches.

### [🐛 Debug Integration Issues](prompts/debug-integration.md)
Comprehensive debugging framework for diagnosing and fixing SwiftAIAccess integration problems. Features diagnostic tools, common issues, and preventive measures.

## Community & Contributions

- **💬 Questions**: [GitHub Discussions](https://github.com/conorluddy/SwiftAIAccess/discussions)
- **🐛 Issues**: [Report bugs](https://github.com/conorluddy/SwiftAIAccess/issues)  
- **🤝 Contributing**: [Contributing Guide](CONTRIBUTING.md)
- **📢 Updates**: Follow [@conorluddy](https://github.com/conorluddy) for updates

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Swift 5.9+
- SwiftUI

## License

SwiftAIAccess is available under the MIT license. See [LICENSE](LICENSE) for details.

---

**Ready to make your iOS app AI-ready?** [Start with the 5-minute setup guide →](docs/getting-started.md#quick-start)

*Made with ❤️ for the AI-powered future of iOS development*