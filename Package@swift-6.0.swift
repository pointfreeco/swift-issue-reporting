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
      name: "IssueReporting",
      exclude: ["Resources/509"],
      resources: [
        .process("Resources/600"),
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
  ],
  swiftLanguageVersions: [.v6]
)

#if os(Linux) || os(Windows)
  package.dependencies.append(
    .package(url: "https://github.com/apple/swift-testing", from: "0.11.0")
  )
  package.products.append(
    .library(
      name: "IssueReportingTestSupport",
      type: .dynamic,
      targets: ["IssueReportingTestSupport"]
    )
  )
  package.targets[0].exclude.append("Resources/600")
#endif

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
