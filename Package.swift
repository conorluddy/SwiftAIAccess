// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftAIAccess",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "SwiftAIAccess",
            targets: ["SwiftAIAccess"]
        ),
    ],
    dependencies: [
        // No external dependencies - keeping it lightweight
    ],
    targets: [
        .target(
            name: "SwiftAIAccess",
            dependencies: [],
            path: "Sources/SwiftAIAccess"
        ),
        .testTarget(
            name: "SwiftAIAccessTests",
            dependencies: ["SwiftAIAccess"],
            path: "Tests/SwiftAIAccessTests"
        ),
    ]
)
