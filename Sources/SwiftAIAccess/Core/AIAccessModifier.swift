import SwiftUI
import os

/// A view modifier that applies AI accessibility integration to any SwiftUI view.
///
/// This modifier ensures proper accessibility identifiers, labels, hints, and traits are set,
/// while also enabling interaction logging and coordinate tracking.
public struct AIAccessModifier: ViewModifier {
    let accessible: AIAccessible
    let componentType: String
    let interactionType: AIAccessInteractionType
    let enableLogging: Bool
    let enableTracking: Bool
    
    @State private var isTracking = false
    
    public init(
        accessible: AIAccessible,
        componentType: String = "Component",
        interactionType: AIAccessInteractionType = .button,
        enableLogging: Bool = true,
        enableTracking: Bool = true
    ) {
        self.accessible = accessible
        self.componentType = componentType
        self.interactionType = interactionType
        self.enableLogging = enableLogging
        self.enableTracking = enableTracking
    }
    
    public func body(content: Content) -> some View {
        content
            .accessibilityIdentifier(accessible.computedAIIdentifier)
            .accessibilityLabel(accessible.computedAILabel)
            .accessibilityHint(accessible.computedAIHint)
            .accessibilityValue(componentType)
            .accessibilityAddTraits(interactionType.accessibilityTraits)
            .onTapGesture {
                if enableLogging {
                    logInteraction()
                }
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            if enableTracking && !isTracking {
                                isTracking = true
                                trackElement(geometry: geometry)
                            }
                        }
                        .onChange(of: geometry.frame(in: .global)) { _ in
                            if enableTracking {
                                trackElement(geometry: geometry)
                            }
                        }
                }
            )
    }
    
    private func logInteraction() {
        AIAccessLogger.shared.logInteraction(
            identifier: accessible.computedAIIdentifier,
            action: interactionType.rawValue,
            context: accessible.aiContext
        )
    }
    
    private func trackElement(geometry: GeometryProxy) {
        let frame = geometry.frame(in: .global)
        CoordinateTracker.shared.updateElement(
            identifier: accessible.computedAIIdentifier,
            frame: frame,
            context: accessible.aiContext
        )
    }
}