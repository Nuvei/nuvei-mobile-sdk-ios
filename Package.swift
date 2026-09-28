// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "nuvei-mobile-simply-connect-ios",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "NuveiSimplyConnectSDK",
            targets: ["NuveiSimplyConnectSDKWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift", from: "1.8.2"),
        .package(url: "https://github.com/roberthein/TinyConstraints", from: "4.0.2"),
    ],
    targets: [
        .target(
            name: "NuveiSimplyConnectSDKWrapper",
            dependencies: [
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "TinyConstraints", package: "TinyConstraints"),
                .target(name: "NuveiSimplyConnectSDKFramework")
            ],
            path: "SwiftPM/NuveiSimplyConnectSDKWrapper"
        ),

        .binaryTarget(
            name: "NuveiSimplyConnectSDKFramework",
            path: "NuveiSimplyConnectSDK.xcframework"
        )
    ]
)
