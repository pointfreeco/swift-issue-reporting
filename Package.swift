// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "swift-issue-reporting",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "IssueReporting", targets: ["IssueReporting"]),
    .library(name: "XCTestDynamicOverlay", targets: ["XCTestDynamicOverlay"]),
  ],
  targets: [
    .target(
      name: "IssueReporting",
      exclude: ["Resources/600"],
      resources: [
        .process("Resources/509"),
      ]
    ),
    .testTarget(
      name: "IssueReportingTests",
      dependencies: ["IssueReporting"]
    ),
    .target(
      name: "XCTestDynamicOverlay",
      dependencies: ["IssueReporting"]
    ),
    .testTarget(
      name: "XCTestDynamicOverlayTests",
      dependencies: ["XCTestDynamicOverlay"]
    ),
  ]
)

#if os(Linux) || os(WASI) || os(Windows)
  package.products.append(
    .library(
      name: "IssueReportingTestSupport",
      type: .dynamic,
      targets: ["IssueReportingTestSupport"]
    )
  )
  package.targets[0].exclude.append("Resources/509")
  package.targets.append(
    .target(
      name: "IssueReportingTestSupport"
    )
  )
#endif

#if os(macOS)
  package.dependencies.append(
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  )
#endif
