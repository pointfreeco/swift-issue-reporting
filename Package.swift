// swift-tools-version: 6.0

import Foundation
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
  ],
  swiftLanguageModes: [.v6]
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

// Set `OMIT_DYNAMIC_TEST_SUPPORT=1` to drop the `IssueReportingTestSupport`
// dynamic-library product. Required when targeting platforms without dynamic
// linking (`wasm32-unknown-wasip1`), where SwiftPM's auto-link of `.dynamic`
// products into test build plans fails.
if ProcessInfo.processInfo.environment["OMIT_DYNAMIC_TEST_SUPPORT"] != nil {
  package.products.removeAll { $0.name == "IssueReportingTestSupport" }
  package.targets.removeAll {
    ["IssueReportingTestSupport", "IssueReportingTests", "XCTestDynamicOverlayTests"]
      .contains($0.name)
  }
}
