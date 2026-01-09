// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataPoolModule",
    products: [
        .library(name: "DataPoolCore", targets: ["DataPoolCore"]),
        .library(name: "DataPoolCategories", targets: ["DataPoolCategories"]),
        .library(name: "DataPoolCategoryItems", targets: ["DataPoolCategoryItems"]),
        .library(name: "DataPoolItem", targets: ["DataPoolItem"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "DataPoolCore", dependencies: []),
        .target(name: "DataPoolCategories", dependencies: ["DataPoolCore"]),
        .target(name: "DataPoolCategoryItems", dependencies: ["DataPoolCore"]),
        .target(name: "DataPoolItem", dependencies: ["DataPoolCore"]),
        .testTarget(
            name: "DataPoolModuleTests",
            dependencies: ["DataPoolModule"]
        ),
    ]
)

//let package = Package(
//    name: "MapFeatures",
//    products: [
//        .library(name: "MapCore", targets: ["MapCore"]),
//        .library(name: "MapShops", targets: ["MapShops"]),
//        .library(name: "MapBuses", targets: ["MapBuses"]),
//    ],
//    dependencies: [],
//    targets: [
//        .target(name: "MapCore", dependencies: []),
//        .target(name: "MapShops", dependencies: ["MapCore"]),
//        .target(name: "MapBuses", dependencies: ["MapCore"]),
//    ]
//)
