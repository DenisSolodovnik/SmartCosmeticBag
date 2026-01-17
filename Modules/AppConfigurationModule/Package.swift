// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppConfigurationModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "AppConfigurationModule",
            targets: ["AppConfigurationModule"]
        ),
    ],
    targets: [
        .target(
            name: "AppConfigurationModule"
        ),
        .testTarget(
            name: "AppConfigurationModuleTests",
            dependencies: ["AppConfigurationModule"]
        ),
    ]
)
