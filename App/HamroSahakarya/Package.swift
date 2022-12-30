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
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "DataSource", targets: ["DataSource"]),
        .library(name: "Core", targets: ["Core"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/kean/Nuke", exact: "11.5.1"),
//        .package(url: "https://github.com/mxcl/PromiseKit", exact: "6.18.1"),
//        .package(url: "https://github.com/danielgindi/Charts", exact: "4.1.0"),
//        .package(url: "https://github.com/ReactiveX/RxSwift", exact: "6.5.0"),
//        .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "10.3.0"),
//        .package(url: "https://github.com/alickbass/CodableFirebase", branch: "master"),
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
        ),
        // Core
        .target(
            name: "Core",
            dependencies: []
        ),
        .target(
            name: "AppUI",
            resources: [
                .process("Resources"),
            ]
        )
    ]
)
