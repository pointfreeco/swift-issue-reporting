#if os(WASI)
  public let isTesting = false
#else
  import Foundation

  /// Whether or not the current process is running tests.
  ///
  /// This detects tests hosted by Xcode/XCTest, SwiftPM (`swift test`), and Bazel (`swift_test`,
  /// including Swift Testing) across Apple platforms and Linux.
  ///
  /// You can use this information to prevent application code from running when hosting tests. For
  /// example, you can wrap your app entry point:
  ///
  /// ```swift
  /// import IssueReporting
  ///
  /// @main
  /// struct MyApp: App {
  ///   var body: some Scene {
  ///     WindowGroup {
  ///       if !isTesting {
  ///         MyRootView()
  ///       }
  ///     }
  ///   }
  /// }
  ///
  /// To detect if the current task is running inside a test, use ``TestContext/current``, instead.
  public let isTesting = ProcessInfo.processInfo.isTesting

  extension ProcessInfo {
    fileprivate var isTesting: Bool {
      if environment.keys.contains("XCTestBundlePath") { return true }
      if environment.keys.contains("XCTestBundleInjectPath") { return true }
      if environment.keys.contains("XCTestConfigurationFilePath") { return true }
      if environment.keys.contains("XCTestSessionIdentifier") { return true }

      // Bazel sets these environment variables for every 'bazel test' run, on all platforms
      // (Linux and Apple) and regardless of the test framework (XCTest, Swift Testing, or a
      // custom 'swift_test' binary). Bazel's "test encyclopedia" guarantees that 'BAZEL_TEST'
      // and 'TEST_SRCDIR' are present for test executables. Note that, because these are
      // inherited by child processes, a non-test process spawned by a Bazel test will also be
      // detected as testing, which matches how the 'XCTest*' variables above behave.
      if environment.keys.contains("BAZEL_TEST") { return true }
      if environment.keys.contains("TEST_SRCDIR") { return true }

      return arguments.contains { argument in
        let path = URL(fileURLWithPath: argument)
        return path.lastPathComponent == "swiftpm-testing-helper"
          || argument == "--testing-library"
          || path.lastPathComponent == "xctest"
          || path.pathExtension == "xctest"
      }
    }
  }
#endif
