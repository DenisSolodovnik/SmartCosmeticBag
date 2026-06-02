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
        .package(name: "LoggerModule", path: "../LoggerModule"),
        .package(name: "DesignModule", path: "../DesignModule"),
        .package(name: "CosmeticRepositoryModule", path: "../CosmeticRepositoryModule"),
        .package(url: "https://github.com/DenisSolodovnik/ProfilerKit.git", from: "1.0.0"),
        .package(name: "PhotoStorage", path: "../PhotoStorage")
    ],
    targets: [
        .target(
            name: "CosmeticModule",
            dependencies: [
                "DesignModule",
                "LoggerModule",
                .product(name: "CosmeticRepositoryModule", package: "CosmeticRepositoryModule"),
                .product(name: "ProfilerKit", package: "ProfilerKit"),
                .product(name: "PhotoStorage", package: "PhotoStorage")
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
