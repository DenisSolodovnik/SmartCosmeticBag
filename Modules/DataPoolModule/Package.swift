// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataPoolModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "DataPoolCore", targets: ["DataPoolCore"]),
        .library(name: "DataPoolCategories", targets: ["DataPoolCategories"]),
        .library(name: "DataPoolCategoryItems", targets: ["DataPoolCategoryItems"]),
        .library(name: "DataPoolItem", targets: ["DataPoolItem"])
    ],
    targets: [
        .target(name: "DataPoolCore", dependencies: []),
        .target(name: "DataPoolCategories", dependencies: ["DataPoolCore"]),
        .target(name: "DataPoolCategoryItems", dependencies: ["DataPoolCore"]),
        .target(name: "DataPoolItem", dependencies: ["DataPoolCore"]),
        .testTarget(
            name: "DataPoolModuleTests",
            dependencies: [
                "DataPoolCore",
                "DataPoolCategoryItems",
                "DataPoolItem"
            ]
        )
    ]
)
