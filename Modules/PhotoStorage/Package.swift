// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhotoStorage",
    platforms: [ .iOS(.v17)],
    products: [
        .library(
            name: "PhotoStorage",
            targets: ["PhotoStorage"]
        ),
    ],
    dependencies: [
        .package(name: "LoggerModule", path: "../LoggerModule")
    ],
    targets: [
        .target(
            name: "PhotoStorage",
            dependencies: [
                "LoggerModule"
            ]
        ),
        .testTarget(
            name: "PhotoStorageTests",
            dependencies: ["PhotoStorage"]
        ),
    ]
)
