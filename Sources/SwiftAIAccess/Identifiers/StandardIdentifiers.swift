import Foundation

/// Standard identifier patterns for common UI components.
///
/// These helpers ensure consistent naming across your app, making it easier
/// for AI agents to understand and navigate your interface.
public enum StandardIdentifiers {
    
    /// Generate identifier for a button
    /// - Parameters:
    ///   - variant: Button variant (primary, secondary, danger, etc.)
    ///   - title: Button title or action
    ///   - context: Optional context prefix
    /// - Returns: Formatted identifier string
    public static func button(_ variant: String = "default", _ title: String, context: String? = nil) -> String {
        let base = "button_\(variant)_\(normalize(title))"
        return context.map { "\($0)_\(base)" } ?? base
    }
    
    /// Generate identifier for a text field
    /// - Parameters:
    ///   - placeholder: Field placeholder or label
    ///   - context: Optional context prefix
    /// - Returns: Formatted identifier string
    public static func textField(_ placeholder: String, context: String? = nil) -> String {
        let base = "textfield_\(normalize(placeholder))"
        return context.map { "\($0)_\(base)" } ?? base
    }
    
    /// Generate identifier for a navigation item
    /// - Parameters:
    ///   - destination: Navigation destination
    ///   - context: Optional context prefix
    /// - Returns: Formatted identifier string
    public static func navigation(_ destination: String, context: String? = nil) -> String {
        let base = "navigation_\(normalize(destination))"
        return context.map { "\($0)_\(base)" } ?? base
    }
    
    /// Generate identifier for a list item
    /// - Parameters:
    ///   - title: Item title
    ///   - index: Optional index in list
    ///   - context: Optional context prefix
    /// - Returns: Formatted identifier string
    public static func listItem(_ title: String, index: Int? = nil, context: String? = nil) -> String {
        var base = "list_item_\(normalize(title))"
        if let index = index {
            base += "_\(index)"
        }
        return context.map { "\($0)_\(base)" } ?? base
    }
    
    /// Generate identifier for a card component
    /// - Parameters:
    ///   - title: Card title
    ///   - context: Optional context prefix
    /// - Returns: Formatted identifier string
    public static func card(_ title: String, context: String? = nil) -> String {
        let base = "card_\(normalize(title))"
        return context.map { "\($0)_\(base)" } ?? base
    }
    
    /// Generate identifier for a toggle/switch
    /// - Parameters:
    ///   - setting: Setting name
    ///   - context: Optional context prefix
    /// - Returns: Formatted identifier string
    public static func toggle(_ setting: String, context: String? = nil) -> String {
        let base = "toggle_\(normalize(setting))"
        return context.map { "\($0)_\(base)" } ?? base
    }
    
    /// Generate identifier for a tab
    /// - Parameters:
    ///   - name: Tab name
    ///   - context: Optional context prefix
    /// - Returns: Formatted identifier string
    public static func tab(_ name: String, context: String? = nil) -> String {
        let base = "tab_\(normalize(name))"
        return context.map { "\($0)_\(base)" } ?? base
    }
    
    /// Generate identifier for a modal/sheet
    /// - Parameters:
    ///   - name: Modal name or purpose
    ///   - context: Optional context prefix
    /// - Returns: Formatted identifier string
    public static func modal(_ name: String, context: String? = nil) -> String {
        let base = "modal_\(normalize(name))"
        return context.map { "\($0)_\(base)" } ?? base
    }
    
    /// Generate identifier for an alert
    /// - Parameters:
    ///   - type: Alert type (error, warning, success, info)
    ///   - message: Alert message or title
    ///   - context: Optional context prefix
    /// - Returns: Formatted identifier string
    public static func alert(_ type: String, _ message: String, context: String? = nil) -> String {
        let base = "alert_\(type)_\(normalize(message))"
        return context.map { "\($0)_\(base)" } ?? base
    }
    
    /// Generate identifier for a badge
    /// - Parameters:
    ///   - type: Badge type
    ///   - value: Badge value or label
    ///   - context: Optional context prefix
    /// - Returns: Formatted identifier string
    public static func badge(_ type: String, _ value: String, context: String? = nil) -> String {
        let base = "badge_\(type)_\(normalize(value))"
        return context.map { "\($0)_\(base)" } ?? base
    }
    
    // MARK: - Helper Methods
    
    /// Normalize a string for use in an identifier
    /// - Parameter string: String to normalize
    /// - Returns: Normalized string
    private static func normalize(_ string: String) -> String {
        string
            .lowercased()
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: "\"", with: "")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: "!", with: "")
            .replacingOccurrences(of: "&", with: "and")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "\\", with: "_")
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined(separator: "_")
            .replacingOccurrences(of: "__+", with: "_", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "_"))
    }
}