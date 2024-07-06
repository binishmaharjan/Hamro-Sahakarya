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
        .library(name: "UserSessionClient", targets: ["UserSessionClient"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        .library(name: "UserAuthClient", targets: ["UserAuthClient"]),
        .library(name: "UserDataClient", targets: ["UserDataClient"]),
        .library(name: "UserLogClient", targets: ["UserLogClient"]),
        .library(name: "UserStorageClient", targets: ["UserStorageClient"]),
        .library(name: "UserApiClient", targets: ["UserApiClient"]),
        .library(name: "AppFeatureV2", targets: ["AppFeatureV2"]),
        .library(name: "OnboardingFeatureV2", targets: ["OnboardingFeatureV2"]),
        .library(name: "SignedInFeatureV2", targets: ["SignedInFeatureV2"]),
        .library(name: "HomeFeatureV2", targets: ["HomeFeatureV2"]),
        .library(name: "LogsFeatureV2", targets: ["LogsFeatureV2"]),
        .library(name: "ProfileFeatureV2", targets: ["ProfileFeatureV2"]),
        .library(name: "NoticeFeatureV2", targets: ["NoticeFeatureV2"]),
        .library(name: "ColorPaletteService", targets: ["ColorPaletteService"]),
        .library(name: "PDFService", targets: ["PDFService"]),
        .library(name: "PhotosService", targets: ["PhotosService"]),
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
            name: "UserSessionClient",
            dependencies: [
                "SharedModels",
                "UserDefaultsClient",
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
                "ColorPaletteService",
                "SharedModels",
                "SharedUIs",
                "UserApiClient",
                "UserSessionClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ColorPaletteService",
            dependencies: [
                "SharedUIs",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "SignedInFeatureV2",
            dependencies: [
                "SharedUIs",
                "UserSessionClient",
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
                "UserSessionClient",
                "UserApiClient",
                "NoticeFeatureV2",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "LogsFeatureV2",
            dependencies: [
                "SharedUIs",
                "UserSessionClient",
                "UserApiClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ProfileFeatureV2",
            dependencies: [
                "SharedUIs",
                "UserSessionClient",
                "UserApiClient",
                "PDFService",
                "PhotosService",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            plugins: [
                .plugin(name: "LicensePlugin")
            ]
        ),
        .target(
            name: "NoticeFeatureV2",
            dependencies: [
                "SharedUIs",
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "PDFService",
            dependencies: [
                "SharedUIs"
            ]
        ),
        .target(
            name: "PhotosService",
            dependencies: [
                "SharedUIs",
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
        .plugin(
            name: "LicensePlugin",
            capability: .buildTool()
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
        ),
        .testTarget(
            name: "PhotosServiceTests",
            dependencies: [
                "PhotosService"
            ]
        )
    ]
)
