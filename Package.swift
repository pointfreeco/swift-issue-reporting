// swift-tools-version: 5.9

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
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-issue-reporting-preview", branch: "main"),
  ],
  targets: [
    .target(
      name: "XCTestDynamicOverlay",
      dependencies: [
        .product(name: "IssueReporting", package: "swift-issue-reporting-preview"),
      ]
    ),
    .testTarget(
      name: "XCTestDynamicOverlayTests",
      dependencies: [
        .product(name: "IssueReportingTestSupport", package: "swift-issue-reporting-preview"),
        "XCTestDynamicOverlay",
      ]
    ),
  ]
)

#if os(macOS)
  package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
  ])
#endif
