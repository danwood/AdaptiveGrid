// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "AdaptiveGrid",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "AdaptiveGrid",
            targets: ["AdaptiveGrid"]
        ),
    ],
    targets: [
        .target(
            name: "AdaptiveGrid"
        ),
        .testTarget(
            name: "AdaptiveGridTests",
            dependencies: ["AdaptiveGrid"]
        ),
    ]
)
