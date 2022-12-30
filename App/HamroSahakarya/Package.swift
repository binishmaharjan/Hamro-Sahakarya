// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HamroSahakarya",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "AppKit",targets: ["AppKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AppKit",
            dependencies: []
        ),
        .testTarget(
            name: "AppKitTests",
            dependencies: ["AppKit"]
        ),
    ]
)
