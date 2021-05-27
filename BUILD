load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "XCTestDynamicOverlay",
    srcs = glob(["Sources/XCTestDynamicOverlay/*.swift"]),
    copts = ["-DSWIFT_PACKAGE"],
    module_name = "XCTestDynamicOverlay",
    visibility = ["//visibility:public"],
)
