# LLM Prompt: Implement SwiftAIAccess in New Project

Use this prompt to help AI agents set up SwiftAIAccess in a new iOS project from scratch.

## Prompt Template

```
You are an expert iOS developer helping to implement SwiftAIAccess in a new SwiftUI project. SwiftAIAccess enables AI automation by making UI elements discoverable through the accessibility tree instead of requiring screenshot analysis.

## Context
- Project Type: [New iOS app / New SwiftUI framework / New Package]
- App Purpose: [Brief description of the app's main function]
- Target Audience: [Who will use this app]
- Key Features: [List main features that need AI accessibility]

## Your Task
Implement SwiftAIAccess following these requirements:

### 1. Project Setup
- Add SwiftAIAccess package dependency
- Configure initial settings for debug/production
- Set up basic project structure with AI-first design

### 2. Core Architecture
Create reusable, AI-accessible components including:
- Base button component (PrimaryButton, SecondaryButton)
- Form field components (TextField, SecureField, Picker)
- Navigation components (TabView, NavigationView)
- List components (List rows, Cards)

### 3. Implementation Standards
Follow these SwiftAIAccess patterns:
- Use AIAccessible protocol for reusable components
- Apply StandardIdentifiers for consistent naming
- Add context tracking to all major views
- Implement proper error handling with AIAccessError

### 4. Integration Examples
Provide complete code examples for:
- Login/authentication flow
- Main navigation structure
- Data list/collection presentation
- Form submission workflow

### 5. Testing Setup
Include:
- Unit tests for AI accessibility
- Integration tests with CoordinateTracker
- Example AI automation scripts

## Code Style Requirements
- Follow Swift API Design Guidelines
- Use comprehensive DocC documentation
- Include inline comments explaining AI accessibility concepts
- Provide usage examples for each component

## Deliverables
1. Complete project structure with SwiftAIAccess integration
2. Sample views demonstrating all major UI patterns
3. Comprehensive documentation
4. Test suite covering AI accessibility features
5. Example AI automation workflow

## Success Criteria
- All UI elements have proper AI-accessible identifiers
- AI agents can navigate the app reliably
- VoiceOver accessibility is enhanced, not degraded
- Code follows SwiftAIAccess best practices
- Performance impact is minimal

Begin implementation with the project setup and core architecture.
```

## Usage Example

**User Query:**
"Help me implement SwiftAIAccess in my new fitness tracking app. The app will have user registration, workout logging, progress tracking, and social features."

**LLM Response using this prompt:**
The AI agent will provide complete SwiftAIAccess implementation including:
- Package setup and configuration
- AI-accessible components for fitness app UI patterns
- Complete authentication flow with proper identifiers
- Workout logging forms with validation
- Progress charts and lists with AI navigation
- Social features with proper context tracking
- Test suite and automation examples

## Customization Options

Modify the prompt for specific scenarios:

**For E-commerce Apps:**
```
- App Purpose: E-commerce marketplace for handmade goods
- Key Features: Product browsing, shopping cart, checkout, user reviews
```

**For Social Apps:**
```
- App Purpose: Social networking app for photographers
- Key Features: Photo sharing, comments, messaging, user profiles
```

**For Productivity Apps:**
```
- App Purpose: Task management and collaboration tool
- Key Features: Task creation, project management, team collaboration, notifications
```

## Expected Output Quality

The AI agent should produce:
- ✅ Production-ready SwiftAIAccess integration
- ✅ Comprehensive component library
- ✅ Complete documentation with examples
- ✅ Working test suite
- ✅ Performance optimizations
- ✅ Error handling and edge cases

## Common Issues to Address

The prompt helps AI agents avoid these common mistakes:
- ❌ Forgetting to add context tracking to views
- ❌ Using inconsistent identifier naming
- ❌ Not implementing proper error handling
- ❌ Missing accessibility trait considerations
- ❌ Inadequate testing coverage
- ❌ Performance optimization oversights