// swift-tools-version: 6.0

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
    .library(name: "TestingDynamicOverlay", targets: ["TestingDynamicOverlay"]),
    .library(name: "XCTestDynamicOverlay", targets: ["XCTestDynamicOverlay"]),
  ],
  targets: [
    .target(name: "TestingDynamicOverlay"),
    .testTarget(
      name: "TestingDynamicOverlayTests",
      dependencies: ["TestingDynamicOverlay"]
    ),
    .target(
      name: "XCTestDynamicOverlay",
      dependencies: ["TestingDynamicOverlay"]
    ),
    .testTarget(
      name: "XCTestDynamicOverlayTests",
      dependencies: ["XCTestDynamicOverlay"]
    ),
  ],
  swiftLanguageVersions: [.v6]
)

#if !os(Windows)
  // Add the documentation compiler plugin if possible
  package.dependencies.append(
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  )
#endif
