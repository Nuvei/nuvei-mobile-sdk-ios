// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "NuveiPackage",
	platforms: [.iOS(.v15)],
	
	products: [
		.library(name: "ApplePay", targets: ["ApplePayWrapper"]),
		.library(name: "SimplyConnect", targets: ["SimplyConnectWrapper"]),
		.library(name: "Fields", targets: ["FieldsWrapper"]),
	],
	
	dependencies: [
		//.package(path: "./PayServicePackage"), // ✅ Explicitly add PayServicePackage
		//.package(path: "./CorePackage"), // ✅ Explicitly add CorePackage
		.package(url: "https://github.com/roberthein/TinyConstraints.git", from: "4.0.0")
	],
	targets: [
		.binaryTarget(
			name: "ApplePay",
			path: "./Frameworks/ApplePay.xcframework"
		),
		.binaryTarget(
			name: "Fields",
			path: "./Frameworks/Fields.xcframework"
		),
		.binaryTarget(
			name: "SimplyConnect",
			path: "./Frameworks/SimplyConnect.xcframework"
		),
		.binaryTarget(
			name: "CorePackage",
			path: "./CorePackage/Core.xcframework"
		),
		.binaryTarget(
			name: "PayServicePackage",
			path: "./PayServicePackage/PayService.xcframework"
		),
		.target(
			name: "SimplyConnectWrapper",
			dependencies: [
				"SimplyConnect",
				"PayServicePackage",
				"CorePackage"
			]
		),
		.target(
			name: "FieldsWrapper",
			dependencies: [
				"Fields",
				"PayServicePackage",
				"CorePackage",
				"TinyConstraints"
			]
		),
		.target(
			name: "ApplePayWrapper",
			dependencies: [
				"ApplePay",
				"CorePackage",
				"TinyConstraints"
			]
		)
	],
	swiftLanguageModes: [.v5]
)
