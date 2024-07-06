// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HamroSahakarya",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "HamroSahakarya",targets: ["HamroSahakarya"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "DataSource", targets: ["DataSource"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "OnboardingFeature", targets: ["OnboardingFeature"]),
        .library(name: "SignedInFeature", targets: ["SignedInFeature"]),
        .library(name: "HomeFeature", targets: ["HomeFeature"]),
        .library(name: "LogFeature", targets: ["LogFeature"]),
        .library(name: "ProfileFeature", targets: ["ProfileFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Nuke", exact: "11.5.1"),
        .package(url: "https://github.com/mxcl/PromiseKit", exact: "6.18.1"),
        .package(url: "https://github.com/danielgindi/Charts", exact: "4.1.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift", exact: "6.5.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "10.28.0"),
        .package(url: "https://github.com/alickbass/CodableFirebase", branch: "master"),
//        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", exact: "6.6.1"),
    ],
    targets: [
        // HamroSahakarya
        .target(
            name: "HamroSahakarya",
            dependencies: [
                "AppFeature"
            ]
        ),
        .testTarget(
            name: "AppKitTests",
            dependencies: [
                "HamroSahakarya"
            ]
        ),
        // AppFeature
        .target(
            name: "AppFeature",
            dependencies: [
                "AppUI",
                "DataSource",
                "OnboardingFeature",
                "HomeFeature",
                "LogFeature",
                "ProfileFeature",
                "SignedInFeature",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxSwift", package: "RxSwift"),
            ]
        ),
        // DataSource
        .target(
            name: "DataSource",
            dependencies: [
                "Core",
                .product(name: "PromiseKit", package: "PromiseKit"),
                .product(name: "CodableFirebase", package: "CodableFirebase"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
            ]
        ),
        // Core
        .target(
            name: "Core",
            dependencies: [
                .product(name: "RxCocoa", package: "RxSwift"), // should not depend on this package
                .product(name: "PromiseKit", package: "PromiseKit")
            ]
        ),
        // AppUI
        .target(
            name: "AppUI",
            dependencies: [
                "Core",
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "NukeExtensions", package: "Nuke"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            exclude: [
//                "README.md",
            ],
            resources: [
                .process("Resources"),
            ],
            plugins: [
//                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]
        ),
        // OnboardingFeature
        .target(
            name: "OnboardingFeature",
            dependencies: [
                "AppUI",
                "Core",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxSwift", package: "RxSwift"),
            ]
        ),
        // SignInFeature
        .target(
            name: "SignedInFeature",
            dependencies: [
                "AppUI",
                "Core",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxSwift", package: "RxSwift"),
            ]
        ),
        // HomeFeature
        .target(
            name: "HomeFeature",
            dependencies: [
                "AppUI",
                "Core",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "Charts", package: "Charts"),
            ]
        ),
        // LogFeature
        .target(
            name: "LogFeature",
            dependencies: [
                "AppUI",
                "Core",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxSwift", package: "RxSwift"),
            ]
        ),
        // ProfileFeature
        .target(
            name: "ProfileFeature",
            dependencies: [
                "AppUI",
                "Core",
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "RxSwift", package: "RxSwift"),
            ]
        )
    ]
)
