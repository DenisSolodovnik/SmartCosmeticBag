// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataRepositoryModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CosmeticRepositoryModule",
            targets: ["CosmeticRepositoryModule"]
        )
    ],
    targets: [
        .target(
            name: "CoreRepositoryModule",
            dependencies: [],
            resources: [
                 .process("Resources/CosmeticsCatalog.xcdatamodeld"),
            ]
        ),
        .target(
            name: "CosmeticRepositoryModule",
            dependencies: ["CoreRepositoryModule"]
        ),
        .testTarget(
            name: "DataRepositoryModuleTests",
            dependencies: ["CosmeticRepositoryModule"]
        )
    ]
)
