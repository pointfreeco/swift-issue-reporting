// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  // NB: Keep this for backwards compatibility. Will rename to 'swift-issue-reporting' in 2.0.
  name: "xctest-dynamic-overlay",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "IssueReporting", targets: ["IssueReporting"]),
    .library(
      name: "IssueReportingTestSupport",
      type: .dynamic,
      targets: ["IssueReportingTestSupport"]
    ),
    .library(name: "XCTestDynamicOverlay", targets: ["XCTestDynamicOverlay"]),
  ],
  targets: [
    .target(
      name: "IssueReportingPackageSupport"
    ),
    .target(
      name: "IssueReporting",
      dependencies: [
        "IssueReportingPackageSupport"
      ]
    ),
    .testTarget(
      name: "IssueReportingTests",
      dependencies: [
        "IssueReporting",
        "IssueReportingTestSupport",
      ]
    ),
    .testTarget(
      name: "IssueReportingTestsNoSupport",
      dependencies: [
        "IssueReporting"
      ]
    ),
    .target(
      name: "IssueReportingTestSupport",
      dependencies: [
        "IssueReportingPackageSupport"
      ]
    ),
    .target(
      name: "XCTestDynamicOverlay",
      dependencies: ["IssueReporting"]
    ),
    .testTarget(
      name: "XCTestDynamicOverlayTests",
      dependencies: [
        "IssueReportingTestSupport",
        "XCTestDynamicOverlay",
      ]
    ),
  ]
)

#if os(macOS)
  package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/swiftwasm/carton", from: "1.0.0"),
  ])
  package.targets.append(
    .executableTarget(
      name: "WasmTests",
      dependencies: [
        "IssueReporting"
      ]
    )
  )
#endif
