// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToasterPlus",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ToasterPlus",
            targets: ["Toaster"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Toaster",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "ToasterTests",
            dependencies: ["Toaster"],
            path: "Tests"
        ),
    ]
)

