# Contributing to SwiftAIAccess

Thank you for considering contributing to SwiftAIAccess! This document provides guidelines for contributing to the project.

## Quick Start

1. **Fork** the repository on GitHub
2. **Clone** your fork locally
3. **Create** a feature branch from `main`
4. **Make** your changes
5. **Test** your changes thoroughly
6. **Submit** a pull request

## Development Setup

### Prerequisites

- Xcode 15.0 or later
- Swift 5.9 or later
- macOS 13.0 or later (for development)

### Building the Project

```bash
# Clone your fork
git clone https://github.com/yourusername/SwiftAIAccess.git
cd SwiftAIAccess

# Build the package
swift build

# Run tests
swift test

# Generate Xcode project (optional)
swift package generate-xcodeproj
```

## Code Guidelines

### Swift Style

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use descriptive variable and function names
- Include comprehensive documentation for public APIs
- Keep functions focused and concise

### Documentation

- All public APIs must have comprehensive DocC documentation
- Include code examples in documentation where helpful
- Document parameters, return values, and throwing behavior
- Use proper DocC syntax with `///` comments

Example:
```swift
/// Updates or adds a tracked UI element for AI navigation.
///
/// This method validates the input parameters and adds the element to the tracking
/// system, making it discoverable by AI agents and automation tools.
///
/// - Parameters:
///   - identifier: Unique identifier for the element. Must be alphanumeric with underscores.
///   - frame: The element's frame in screen coordinates
///   - context: Additional metadata for AI understanding
/// - Throws: `AIAccessError` if validation fails or resource limits are exceeded
///
/// ## Example
/// ```swift
/// try tracker.updateElementValidated(
///     identifier: "login_button",
///     frame: CGRect(x: 10, y: 20, width: 100, height: 44),
///     context: ["screen": "authentication"]
/// )
/// ```
public func updateElementValidated(identifier: String, frame: CGRect, context: [String: String] = [:]) throws {
    // Implementation
}
```

### Testing

- Write comprehensive unit tests for all new functionality
- Ensure all tests pass before submitting a PR
- Include edge cases and error conditions in tests
- Use descriptive test names that explain what is being tested

### Error Handling

- Use the `AIAccessError` enum for all SwiftAIAccess-specific errors
- Provide meaningful error messages with recovery suggestions
- Include validation for all public API inputs
- Log errors appropriately with structured logging

## Contribution Types

### Bug Fixes

- Include a clear description of the bug and how to reproduce it
- Reference any related issues
- Include tests that demonstrate the fix

### New Features

- Discuss the feature in an issue before implementation
- Ensure the feature aligns with the project's goals
- Include comprehensive tests and documentation
- Consider backward compatibility

### Documentation Improvements

- Fix typos, improve clarity, or add missing documentation
- Update examples to reflect current best practices
- Ensure all code examples compile and work correctly

### Performance Improvements

- Include benchmarks showing the improvement
- Ensure changes don't break existing functionality
- Document any API changes or requirements

## Pull Request Process

### Before Submitting

1. **Update Documentation**: Ensure all changes are documented
2. **Run Tests**: All tests must pass (`swift test`)
3. **Check Style**: Follow the project's coding conventions
4. **Update CHANGELOG**: Add a brief description of your changes

### PR Description

Include the following in your pull request description:

- **Summary**: Brief description of changes
- **Motivation**: Why is this change needed?
- **Testing**: How did you test the changes?
- **Breaking Changes**: Any API changes or migration requirements
- **Related Issues**: Link to any related GitHub issues

### Review Process

- All PRs require review from a maintainer
- Address feedback promptly and professionally
- Update documentation if requested
- Ensure CI checks pass

## Issue Reporting

### Bug Reports

Include the following information:

- **Description**: Clear description of the issue
- **Steps to Reproduce**: Detailed steps to reproduce the bug
- **Expected Behavior**: What should happen
- **Actual Behavior**: What actually happens
- **Environment**: iOS version, Xcode version, Swift version
- **Code Sample**: Minimal code example demonstrating the issue

### Feature Requests

- **Description**: Clear description of the proposed feature
- **Use Case**: Why is this feature needed?
- **Proposed API**: Suggested API design (if applicable)
- **Alternatives**: Other solutions you've considered

## Code Review Guidelines

### For Contributors

- Respond to review feedback constructively
- Make requested changes promptly
- Ask questions if feedback is unclear
- Keep discussions focused on the code

### For Reviewers

- Be constructive and specific in feedback
- Focus on code quality, not personal preferences
- Explain the reasoning behind suggested changes
- Approve PRs that meet the project standards

## Community Standards

### Code of Conduct

- Be respectful and inclusive
- Focus on constructive collaboration
- Help create a welcoming environment for all contributors
- Report inappropriate behavior to the maintainers

### Communication

- Use GitHub issues for bug reports and feature requests
- Use pull requests for code discussions
- Be patient with response times
- Help other contributors when possible

## Development Workflow

### Git Workflow

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/my-feature`
3. **Commit** changes with clear messages
4. **Push** to your fork: `git push origin feature/my-feature`
5. **Create** a pull request

### Commit Messages

Use clear, descriptive commit messages:

```
Add input validation to CoordinateTracker.updateElement()

- Validate identifier format and length
- Check frame bounds for finite values  
- Prevent resource exhaustion with element limits
- Add comprehensive error messages with recovery suggestions

Fixes #123
```

### Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring

## Release Process

Releases follow semantic versioning (SemVer):

- **Major** (X.0.0): Breaking changes
- **Minor** (0.X.0): New features, backward compatible
- **Patch** (0.0.X): Bug fixes, backward compatible

## Getting Help

- **Documentation**: Check the README and API documentation first
- **Issues**: Search existing issues before creating new ones
- **Questions**: Use GitHub Discussions for general questions
- **Contact**: Reach out to maintainers for urgent issues

## Recognition

Contributors will be recognized in:

- GitHub contributors list
- Release notes for significant contributions
- Special thanks in the README for major features

Thank you for contributing to SwiftAIAccess and helping make iOS apps more accessible to AI agents!