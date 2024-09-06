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
    .library(name: "IssueReporting", targets: ["IssueReporting"]),
    .library(name: "IssueReportingTestSupport", targets: ["IssueReportingTestSupport"]),
    .library(name: "XCTestDynamicOverlay", targets: ["XCTestDynamicOverlay"]),
  ],
  dependencies: [
    // On Apple platforms this is included but not including it will not work on other platforms
    // see section https://swiftpackageindex.com/swiftlang/swift-testing/main/documentation/testing/temporarygettingstarted#Adding-the-testing-library-as-a-dependency
    .package(url: "https://github.com/apple/swift-testing", from: "0.11.0")
  ],
  targets: [
    .target(
      name: "IssueReporting"
    ),
    .testTarget(
      name: "IssueReportingTests",
      dependencies: [
        "IssueReporting",
        "IssueReportingTestSupport",
      ]
    ),
    .target(
      name: "IssueReportingTestSupport",
      dependencies: [.product(name: "Testing", package: "swift-testing")]
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
  swiftLanguageVersions: [.v6]
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
