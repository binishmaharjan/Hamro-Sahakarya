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
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "DataSource", targets: ["DataSource"])
    ],
    dependencies: [
    ],
    targets: [
        // AppKit
        .target(
            name: "AppKit",
            dependencies: [
                "AppFeature"
            ]
        ),
        .testTarget(
            name: "AppKitTests",
            dependencies: [
                "AppKit"
            ]
        ),
        // AppFeature
        .target(
            name: "AppFeature",
            dependencies: []
        ),
        // DataSource
        .target(
            name: "DataSource",
            dependencies: []
        )
    ]
)
