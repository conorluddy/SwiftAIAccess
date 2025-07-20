# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SwiftAIAccess is a Swift package that enables AI-powered navigation and automation in SwiftUI applications while improving accessibility. The package provides protocols, modifiers, and services for making UI elements discoverable by AI agents and testing frameworks.

## Development Commands

### Testing
```bash
swift test
```

### Building
```bash
swift build
```

### Package Resolution
```bash
swift package resolve
```

### Generate Xcode Project (for development)
```bash
swift package generate-xcodeproj
```

## Architecture

### Core Components

The package is organized into several key modules:

- **Core/**: Contains the fundamental protocols and types
  - `AIAccessible` protocol: Main interface for making components AI-discoverable
  - `InteractionType` enum: Defines types of UI interactions (button, input, navigation, etc.)
  - `AIAccessModifier`: SwiftUI view modifier that applies AI accessibility

- **Tracking/**: Coordinate and context tracking
  - `CoordinateTracker`: Singleton that tracks UI element positions and view context
  - Maintains a registry of element frames for precise AI navigation

- **Navigation/**: High-level navigation APIs
  - `NavigationService`: Provides methods for AI automation (tap elements, wait for elements)
  - Returns structured results for automation success/failure

- **Logging/**: Structured interaction logging
  - `AIAccessLogger`: Records user interactions in AI-parseable format
  - Configurable logging levels and custom event handlers

- **Identifiers/**: Standardized naming conventions
  - `StandardIdentifiers`: Helper methods for consistent element naming
  - Format: `{category}_{context}_{element}_{modifier?}`

- **Extensions/**: SwiftUI convenience extensions
  - `View+AIAccess`: Quick access modifiers for common UI patterns

### Key Protocols

- `AIAccessible`: Components implement this to expose AI-discoverable properties
  - Required: `aiIdentifier`, `aiLabel`, `aiHint`, `aiContext`
  - Computed: `computedAIIdentifier`, `computedAILabel`, `computedAIHint`

### Usage Pattern

1. Make views conform to `AIAccessible`
2. Apply `.applyAIAccess(self, interactionType: .button)` modifier
3. Use `.trackContext("ViewName")` for view hierarchy tracking
4. Access tracked elements via `NavigationService` or `CoordinateTracker`

## Testing Approach

Tests are located in `Tests/SwiftAIAccessTests/SwiftAIAccessTests.swift` and cover:
- Identifier generation and normalization
- Coordinate tracking functionality
- Navigation service operations
- Logger behavior
- Interaction type definitions

The test suite uses XCTest and includes async testing for navigation operations.

## Package Dependencies

The package has zero external dependencies to maintain lightweight integration. It only depends on:
- Foundation (re-exported)
- SwiftUI (re-exported)

## Platform Support

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 8.0+
- Swift 5.9+

## Development Notes

- All core services use singleton patterns (`shared` instances)
- Thread-safe implementations for coordinate tracking and logging
- Designed for conditional enablement (can be disabled in production builds)
- Follows consistent naming conventions for AI discoverability
- Integrates with existing accessibility features (VoiceOver compatibility)