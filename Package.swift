// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Light",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Light",
            targets: ["Light"]),
    ],
    dependencies: [
        .package(url: "https://github.com/dreymonde/Shallows.git", from: "0.11.0"),
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Light",
            dependencies: ["Shallows"]),
        .testTarget(
            name: "LightTests",
            dependencies: ["Light"]),
    ]
)
