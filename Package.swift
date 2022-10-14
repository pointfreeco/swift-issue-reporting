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
    .library(name: "XCTestDynamicOverlay", targets: ["XCTestDynamicOverlay"]),
    .library(name: "XCTestDynamicOverlayUnsafe", targets: ["XCTestDynamicOverlayUnsafe"]),
  ],
  targets: [
    .target(name: "RuntimeWarningInternal"),
    .target(
      name: "XCTestDynamicOverlay",
      dependencies: ["RuntimeWarningInternal"]
    ),
    .testTarget(
      name: "XCTestDynamicOverlayTests",
      dependencies: ["XCTestDynamicOverlay"]
    ),
    .target(
      name: "XCTestDynamicOverlayUnsafe",
      dependencies: ["RuntimeWarningInternal"]
    ),
    .testTarget(
      name: "XCTestDynamicOverlayUnsafeTests",
      dependencies: ["XCTestDynamicOverlayUnsafe"]
    ),
  ]
)

#if swift(>=5.6)
  // Add the documentation compiler plugin if possible
  package.dependencies.append(
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  )
#endif
