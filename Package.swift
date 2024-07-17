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
      dependencies: [
        .byName(name: "IssueReportingTestSupport", condition: .when(platforms: [.wasi]))
      ],
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
      name: "IssueReportingTestSupport"
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

#if os(Linux) || os(Windows)
  package.products.append(
    .library(
      name: "IssueReportingTestSupport",
      type: .dynamic,
      targets: ["IssueReportingTestSupport"]
    )
  )
  package.targets[0].exclude.append("Resources/509")
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
