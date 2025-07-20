import XCTest
@testable import SwiftAIAccess

final class SwiftAIAccessTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Clear any existing state
        CoordinateTracker.shared.clearAll()
        AIAccessLogger.shared.isEnabled = true
    }
    
    // MARK: - StandardIdentifiers Tests
    
    func testButtonIdentifierGeneration() {
        let identifier = StandardIdentifiers.button("primary", "Save Changes")
        XCTAssertEqual(identifier, "button_primary_save_changes")
    }
    
    func testButtonIdentifierWithContext() {
        let identifier = StandardIdentifiers.button("secondary", "Cancel", context: "profile")
        XCTAssertEqual(identifier, "profile_button_secondary_cancel")
    }
    
    func testTextFieldIdentifierGeneration() {
        let identifier = StandardIdentifiers.textField("Email Address")
        XCTAssertEqual(identifier, "textfield_email_address")
    }
    
    func testNavigationIdentifierGeneration() {
        let identifier = StandardIdentifiers.navigation("Settings")
        XCTAssertEqual(identifier, "navigation_settings")
    }
    
    func testListItemIdentifierGeneration() {
        let identifier = StandardIdentifiers.listItem("User Profile", index: 0)
        XCTAssertEqual(identifier, "list_item_user_profile_0")
    }
    
    func testCardIdentifierGeneration() {
        let identifier = StandardIdentifiers.card("Recent Activity")
        XCTAssertEqual(identifier, "card_recent_activity")
    }
    
    func testToggleIdentifierGeneration() {
        let identifier = StandardIdentifiers.toggle("Dark Mode")
        XCTAssertEqual(identifier, "toggle_dark_mode")
    }
    
    func testIdentifierNormalization() {
        let identifier = StandardIdentifiers.button("primary", "Save & Continue!")
        XCTAssertEqual(identifier, "button_primary_save_and_continue")
    }
    
    // MARK: - CoordinateTracker Tests
    
    func testCoordinateTrackerSingleton() {
        let tracker1 = CoordinateTracker.shared
        let tracker2 = CoordinateTracker.shared
        XCTAssertIdentical(tracker1, tracker2)
    }
    
    func testElementTracking() {
        let tracker = CoordinateTracker.shared
        let frame = CGRect(x: 10, y: 20, width: 100, height: 50)
        
        tracker.updateElement(identifier: "test_button", frame: frame)
        
        let element = tracker.findElement(identifier: "test_button")
        XCTAssertNotNil(element)
        XCTAssertEqual(element?.frame, frame)
        XCTAssertEqual(element?.identifier, "test_button")
    }
    
    func testElementCenter() {
        let tracker = CoordinateTracker.shared
        let frame = CGRect(x: 10, y: 20, width: 100, height: 50)
        
        tracker.updateElement(identifier: "test_element", frame: frame)
        
        let element = tracker.findElement(identifier: "test_element")
        XCTAssertEqual(element?.center, CGPoint(x: 60, y: 45))
    }
    
    func testElementRemoval() {
        let tracker = CoordinateTracker.shared
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        tracker.updateElement(identifier: "test_element", frame: frame)
        XCTAssertNotNil(tracker.findElement(identifier: "test_element"))
        
        tracker.removeElement(identifier: "test_element")
        XCTAssertNil(tracker.findElement(identifier: "test_element"))
    }
    
    func testViewContextTracking() {
        let tracker = CoordinateTracker.shared
        let metadata = ["user_id": "123", "section": "profile"]
        
        tracker.updateViewContext(name: "ProfileView", metadata: metadata)
        
        XCTAssertEqual(tracker.currentViewContext, "ProfileView")
        XCTAssertEqual(tracker.viewContextMetadata, metadata)
    }
    
    func testElementsInRegion() {
        let tracker = CoordinateTracker.shared
        
        tracker.updateElement(identifier: "element1", frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        tracker.updateElement(identifier: "element2", frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        tracker.updateElement(identifier: "element3", frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        
        let region = CGRect(x: 0, y: 0, width: 100, height: 100)
        let elementsInRegion = tracker.elementsInRegion(region)
        
        XCTAssertEqual(elementsInRegion.count, 2)
        let identifiers = elementsInRegion.map { $0.identifier }
        XCTAssertTrue(identifiers.contains("element1"))
        XCTAssertTrue(identifiers.contains("element3"))
        XCTAssertFalse(identifiers.contains("element2"))
    }
    
    func testTrackingSnapshot() {
        let tracker = CoordinateTracker.shared
        let frame = CGRect(x: 10, y: 20, width: 100, height: 50)
        
        tracker.updateElement(identifier: "test_element", frame: frame)
        tracker.updateViewContext(name: "TestView", metadata: ["test": "value"])
        
        let snapshot = tracker.snapshot()
        
        XCTAssertEqual(snapshot.viewContext, "TestView")
        XCTAssertEqual(snapshot.viewMetadata["test"], "value")
        XCTAssertEqual(snapshot.elements.count, 1)
        XCTAssertNotNil(snapshot.elements["test_element"])
    }
    
    // MARK: - AIAccessLogger Tests
    
    func testLoggerSingleton() {
        let logger1 = AIAccessLogger.shared
        let logger2 = AIAccessLogger.shared
        XCTAssertIdentical(logger1, logger2)
    }
    
    func testLoggingEnabled() {
        let logger = AIAccessLogger.shared
        logger.isEnabled = true
        XCTAssertTrue(logger.isEnabled)
        
        logger.isEnabled = false
        XCTAssertFalse(logger.isEnabled)
    }
    
    // MARK: - NavigationService Tests
    
    func testNavigationServiceSingleton() {
        let service1 = NavigationService.shared
        let service2 = NavigationService.shared
        XCTAssertIdentical(service1, service2)
    }
    
    func testTapElementNotFound() {
        let service = NavigationService.shared
        let expectation = XCTestExpectation(description: "Element not found")
        
        service.tapElement("nonexistent_element") { result in
            switch result {
            case .elementNotFound(let identifier):
                XCTAssertEqual(identifier, "nonexistent_element")
                expectation.fulfill()
            default:
                XCTFail("Expected elementNotFound result")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testTapElementSuccess() {
        let service = NavigationService.shared
        let tracker = CoordinateTracker.shared
        let expectation = XCTestExpectation(description: "Element tapped successfully")
        
        // Set up a tracked element
        tracker.updateElement(
            identifier: "test_button",
            frame: CGRect(x: 10, y: 10, width: 100, height: 50)
        )
        
        service.tapElement("test_button") { result in
            switch result {
            case .success:
                expectation.fulfill()
            default:
                XCTFail("Expected success result")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFindElementsMatching() {
        let service = NavigationService.shared
        let tracker = CoordinateTracker.shared
        
        tracker.updateElement(identifier: "button_primary_save", frame: CGRect.zero)
        tracker.updateElement(identifier: "button_secondary_cancel", frame: CGRect.zero)
        tracker.updateElement(identifier: "textfield_email", frame: CGRect.zero)
        
        let buttonElements = service.findElements(matching: "button_.*")
        XCTAssertEqual(buttonElements.count, 2)
        XCTAssertTrue(buttonElements.contains("button_primary_save"))
        XCTAssertTrue(buttonElements.contains("button_secondary_cancel"))
    }
    
    func testGetCurrentContext() {
        let service = NavigationService.shared
        let tracker = CoordinateTracker.shared
        
        tracker.updateViewContext(name: "TestView", metadata: ["key": "value"])
        
        let (view, metadata) = service.getCurrentContext()
        XCTAssertEqual(view, "TestView")
        XCTAssertEqual(metadata["key"], "value")
    }
    
    // MARK: - InteractionType Tests
    
    func testInteractionTypeAccessibilityTraits() {
        XCTAssertEqual(AIAccessInteractionType.button.accessibilityTraits, .isButton)
        XCTAssertEqual(AIAccessInteractionType.navigation.accessibilityTraits, .isButton)
        XCTAssertEqual(AIAccessInteractionType.toggle.accessibilityTraits, [.isButton])
        XCTAssertEqual(AIAccessInteractionType.selection.accessibilityTraits, [.isButton, .isSelected])
        XCTAssertEqual(AIAccessInteractionType.input.accessibilityTraits, [])
        XCTAssertEqual(AIAccessInteractionType.display.accessibilityTraits, [])
        XCTAssertEqual(AIAccessInteractionType.container.accessibilityTraits, [])
    }
    
    func testInteractionTypeDescriptions() {
        XCTAssertEqual(AIAccessInteractionType.button.description, "Button")
        XCTAssertEqual(AIAccessInteractionType.navigation.description, "Navigation")
        XCTAssertEqual(AIAccessInteractionType.input.description, "Input Field")
        XCTAssertEqual(AIAccessInteractionType.display.description, "Display")
        XCTAssertEqual(AIAccessInteractionType.container.description, "Container")
        XCTAssertEqual(AIAccessInteractionType.toggle.description, "Toggle")
        XCTAssertEqual(AIAccessInteractionType.selection.description, "Selection")
        XCTAssertEqual(AIAccessInteractionType.draggable.description, "Draggable")
    }
}
