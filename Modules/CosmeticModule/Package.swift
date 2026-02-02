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
        .package(name: "DataPoolModule", path: "../DataPoolModule")
    ],
    targets: [
        .target(
            name: "CosmeticModule",
            dependencies: [
                "DesignModule",
                .product(name: "CosmeticDataPool", package: "DataPoolModule")
            ]
        ),
        .testTarget(
            name: "CosmeticModuleTests",
            dependencies: [
                "CosmeticModule",
                .product(name: "CosmeticDataPool", package: "DataPoolModule")
            ]
        ),
    ]
)
