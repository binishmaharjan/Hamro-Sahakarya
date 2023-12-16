// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HamroSahakaryaV2",
    products: [
        .library(name: "HamroSahakaryaV2",targets: ["HamroSahakaryaV2"]),
    ],
    targets: [
        .target(
            name: "HamroSahakaryaV2"
        ),
        .testTarget(
            name: "HamroSahakaryaV2Tests",
            dependencies: ["HamroSahakaryaV2"]
        ),
    ]
)
