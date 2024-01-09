// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIMenu",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftUIMenu",
            targets: ["SwiftUIMenu"]),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.1.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUIMenu",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect"),
            ]//,
            // swiftSettings: [
            //     .define("MENU_DEBUG", .when(configuration: .debug)),
            // ]
        ),
        .testTarget(
            name: "SwiftUIMenuTests",
            dependencies: ["SwiftUIMenu"]),
    ]
)
