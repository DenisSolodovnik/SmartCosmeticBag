// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CosmeticModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "CosmeticModule", targets: ["CosmeticModule"]),
    ],
    dependencies: [
        .package(name: "DesignModule", path: "../DesignModule"),
        .package(name: "AppConfigurationModule", path: "../AppConfigurationModule")
    ],
    targets: [
        .target(
            name: "CosmeticModule",
            dependencies: [
                "DesignModule",
                "AppConfigurationModule"
            ]
        ),
        .testTarget(
            name: "CosmeticModuleTests",
            dependencies: ["CosmeticModule"]
        ),
    ]
)
