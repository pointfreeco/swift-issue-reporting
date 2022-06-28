// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "xctest-dynamic-overlay",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "XCTestDynamicOverlay", targets: ["XCTestDynamicOverlay"])
  ],
  targets: [
    .target(
      name: "XCTestDynamicOverlay",
      swiftSettings: [
        .unsafeFlags(["-Xfrontend", "-warn-concurrency"]),
      ]
    ),
    .testTarget(
      name: "XCTestDynamicOverlayTests",
      dependencies: ["XCTestDynamicOverlay"]
    ),
  ]
)
