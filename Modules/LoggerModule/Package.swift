// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoggerModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "LoggerModule",
            targets: ["LoggerModule"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/appmetrica/appmetrica-sdk-ios", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "LoggerModule",
            dependencies: [
                .product(name: "AppMetricaAnalytics", package: "appmetrica-sdk-ios"),
            ]
        ),
        .testTarget(
            name: "LoggerModuleTests",
            dependencies: ["LoggerModule"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
