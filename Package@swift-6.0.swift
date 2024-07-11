// swift-tools-version: 6.0

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
      name: "IssueReporting"
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
  ],
  swiftLanguageVersions: [.v6]
)

let testSupportVersion: Version = "0.1.0"
#if os(macOS)
  package.targets.append(
    .binaryTarget(
      name: "IssueReportingTestSupport",
      // url: "https://github.com/pointfreeco/swift-issue-reporting-support/release/\(testSupportVersion)/TODO",
      // checksum: "TODO"
      path: "Sources/IssueReportingTestSupport.xcframework"
    )
  )
#else
  // package.dependencies.append(
  //   .package(
  //     url: "https://github.com/pointfreeco/swift-issue-reporting-support",
  //     from: testSupportVersion
  //   )
  // )
#endif

for target in package.targets {
  if target.name == "IssueReporting" {
    // #if os(macOS)
      target.dependencies.append("IssueReportingTestSupport")
    // #else
    //   target.dependencies.append(
    //     .product(name: "IssueReportingTestSupport", package: "swift-issue-reporting-support")
    //   )
    // #endif
  }
}

#if !os(Windows)
  // Add the documentation compiler plugin if possible
  package.dependencies.append(
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
  )
#endif
