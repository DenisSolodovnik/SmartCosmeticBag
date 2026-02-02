// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataPoolModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "CosmeticDataPool", targets: ["CosmeticDataPool"])
    ],
    targets: [
        .target(name: "CosmeticDataPool", dependencies: []),
        .testTarget(
            name: "DataPoolModuleTests",
            dependencies: [
                "CosmeticDataPool"
            ]
        )
    ]
)

