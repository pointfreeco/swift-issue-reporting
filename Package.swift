// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "xctest-dynamic-overlay",
  products: [
    .library(name: "XCTestDynamicOverlay", targets: ["XCTestDynamicOverlay"])
  ],
  targets: [
    .target(name: "XCTestDynamicOverlay"),
    .testTarget(
      name: "XCTestDynamicOverlayTests",
      dependencies: ["XCTestDynamicOverlay"]
    ),
  ]
)
