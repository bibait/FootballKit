// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FootballKit",
    products: [
        .library(
            name: "FootballKit",
            targets: ["FootballKit"]),
    ],
    targets: [
        .target(
            name: "FootballKit"),
        .testTarget(
            name: "FootballKitTests",
            dependencies: ["FootballKit"]
        ),
    ]
)
