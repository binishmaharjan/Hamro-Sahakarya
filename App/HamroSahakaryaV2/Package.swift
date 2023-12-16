// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HamroSahakaryaV2",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "HamroSahakaryaV2",targets: ["HamroSahakaryaV2"]),
        .library(name: "AppFeatureV2", targets: ["AppFeatureV2"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.5.5"),
    ],
    targets: [
        .target(
            name: "HamroSahakaryaV2",
            dependencies: [
                "AppFeatureV2",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AppFeatureV2",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "HamroSahakaryaV2Tests",
            dependencies: ["HamroSahakaryaV2"]
        ),
    ]
)
