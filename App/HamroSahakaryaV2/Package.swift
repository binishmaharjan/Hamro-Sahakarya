// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "HamroSahakaryaV2",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v12)],
    products: [
        .library(name: "HamroSahakaryaV2",targets: ["HamroSahakaryaV2"]),
        .library(name: "AppFeatureV2", targets: ["AppFeatureV2"]),
        .library(name: "AuthClient", targets: ["AuthClient"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "SharedUIs", targets: ["SharedUIs"]),
        .library(name: "OnboardingFeatureV2", targets: ["OnboardingFeatureV2"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.5.5"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "10.19.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.2"),
    ],
    targets: [
        .target(
            name: "HamroSahakaryaV2",
            dependencies: [
                "AppFeatureV2",
                "SharedUIs",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AppFeatureV2",
            dependencies: [
                "OnboardingFeatureV2",
                "UserDefaultsClient",
                "SharedUIs",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "OnboardingFeatureV2",
            dependencies: [
                "SharedUIs",
                "AuthClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AuthClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: [
                "SharedUIs",
            ]
        ),
        .target(
            name: "SharedUIs",
            dependencies: [
                "SharedMacros",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .macro(
            name: "SharedMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "HamroSahakaryaV2Tests",
            dependencies: [
                "HamroSahakaryaV2"
            ]
        ),
        .testTarget(
            name: "AppFeatureV2Tests",
            dependencies: [
                "AppFeatureV2"
            ]
        ),
    ]
)
