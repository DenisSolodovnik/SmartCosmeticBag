// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CosmeticModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "CosmeticModule", targets: ["CosmeticModule"])
    ],
    dependencies: [
        .package(name: "DesignModule", path: "../DesignModule"),
        .package(name: "DataRepositoryModule", path: "../DataRepositoryModule"),
        .package(url: "https://github.com/DenisSolodovnik/ProfilerKit.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "CosmeticModule",
            dependencies: [
                "DesignModule",
                .product(name: "CosmeticRepositoryModule", package: "DataRepositoryModule"),
                .product(name: "ProfilerKit", package: "ProfilerKit")
            ]
        ),
        .testTarget(
            name: "CosmeticModuleTests",
            dependencies: [
                "CosmeticModule"
            ]
        )
    ]
)
