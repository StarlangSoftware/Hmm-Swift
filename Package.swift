// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Hmm",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Hmm",
            targets: ["Hmm"]),
    ],
    dependencies: [
        .package(name: "Math", url: "https://github.com/StarlangSoftware/Math-Swift.git", .exact("1.0.3")),
        .package(name: "DataStructure", url: "https://github.com/StarlangSoftware/DataStructure-Swift.git", .exact("1.0.4")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Hmm",
            dependencies: ["Math", "DataStructure"]),
        .testTarget(
            name: "HmmTests",
            dependencies: ["Hmm"]),
    ]
)
