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
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "SharedUIs", targets: ["SharedUIs"]),
        .library(name: "SwiftHelpers", targets: ["SwiftHelpers"]),
        .library(name: "UserSession", targets: ["UserSession"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        .library(name: "UserAuthClient", targets: ["UserAuthClient"]),
        .library(name: "UserDataClient", targets: ["UserDataClient"]),
        .library(name: "UserLogClient", targets: ["UserLogClient"]),
        .library(name: "UserStorageClient", targets: ["UserStorageClient"]),
        .library(name: "UserApiClient", targets: ["UserApiClient"]),
        .library(name: "AppFeatureV2", targets: ["AppFeatureV2"]),
        .library(name: "OnboardingFeatureV2", targets: ["OnboardingFeatureV2"]),
        .library(name: "ColorPaletteFeatureV2", targets: ["ColorPaletteFeatureV2"]),
        .library(name: "SignedInFeatureV2", targets: ["SignedInFeatureV2"]),
        .library(name: "HomeFeatureV2", targets: ["HomeFeatureV2"]),
        .library(name: "LogsFeatureV2", targets: ["LogsFeatureV2"]),
        .library(name: "ProfileFeatureV2", targets: ["ProfileFeatureV2"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.9.2"),
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
            name: "SharedModels",
            dependencies: [
                "SharedUIs",
                "SwiftHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "SharedUIs",
            dependencies: [
                "SharedMacros",
                "SwiftHelpers",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "SwiftHelpers",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "UserSession",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
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
            name: "UserAuthClient",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "UserDataClient",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "UserStorageClient",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "UserLogClient",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "UserApiClient",
            dependencies: [
                "UserAuthClient",
                "UserDataClient",
                "UserLogClient",
                "UserStorageClient",
                "UserDefaultsClient",
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "AppFeatureV2",
            dependencies: [
                "UserDefaultsClient",
                "SharedUIs",
                "OnboardingFeatureV2",
                "SignedInFeatureV2",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "OnboardingFeatureV2",
            dependencies: [
                "ColorPaletteFeatureV2",
                "SharedModels",
                "SharedUIs",
                "UserApiClient",
                "UserSession",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ColorPaletteFeatureV2",
            dependencies: [
                "SharedUIs",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "SignedInFeatureV2",
            dependencies: [
                "SharedUIs",
                "UserSession",
                "HomeFeatureV2",
                "LogsFeatureV2",
                "ProfileFeatureV2",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "HomeFeatureV2",
            dependencies: [
                "SharedUIs",
                "UserSession",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "LogsFeatureV2",
            dependencies: [
                "SharedUIs",
                "UserSession",
                "UserApiClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ProfileFeatureV2",
            dependencies: [
                "SharedUIs",
                "UserSession",
                "UserApiClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
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
        .testTarget(
            name: "OnboardingFeatureV2Tests",
            dependencies: [
                "OnboardingFeatureV2"
            ]
        ),
        .testTarget(
            name: "LogsFeatureV2Tests",
            dependencies: [
                "LogsFeatureV2"
            ]
        ),
        .testTarget(
            name: "ProfileFeatureV2Tests",
            dependencies: [
                "ProfileFeatureV2"
            ]
        )
    ]
)
