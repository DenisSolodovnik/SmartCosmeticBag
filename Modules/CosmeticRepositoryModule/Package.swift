// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CosmeticRepositoryModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CosmeticRepositoryModule",
            targets: ["CosmeticRepositoryModule"]
        )
    ],
    dependencies: [
        .package(name: "LoggerModule", path: "../LoggerModule")
    ],
    targets: [
        .target(
            name: "CosmeticRepositoryModule",
            dependencies: [
                "LoggerModule"
            ],
            resources: [
                .process("Resources/CosmeticsCatalog.xcdatamodeld")
            ]
        ),
        .testTarget(
            name: "CosmeticRepositoryModuleTests",
            dependencies: ["CosmeticRepositoryModule"]
        )
    ]
)
