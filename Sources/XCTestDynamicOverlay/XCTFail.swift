#if DEBUG
  #if canImport(ObjectiveC)
    import Foundation

    /// This function generates a failure immediately and unconditionally.
    ///
    /// Dynamically creates and records an `XCTIssue` under the hood that captures the source code
    /// context of the caller. Useful for defining assertion helpers that fail in indirect code
    /// paths, where the `file` and `line` of the failure have not been realized.
    ///
    /// - Parameter message: An optional description of the assertion, for inclusion in test
    ///   results.
    @_disfavoredOverload
    public func XCTFail(_ message: String = "") {
      let message = appendHostAppWarningIfNeeded(message)
      guard
        let currentTestCase = XCTCurrentTestCase,
        let XCTIssue = NSClassFromString("XCTIssue")
          as Any as? NSObjectProtocol,
        let alloc = XCTIssue.perform(NSSelectorFromString("alloc"))?
          .takeUnretainedValue(),
        let issue =
          alloc
          .perform(
            Selector(("initWithType:compactDescription:")),
            with: 0,
            with: message.isEmpty ? "failed" : message
          )?
          .takeUnretainedValue()
      else {
        if !_XCTIsTesting {
          runtimeWarn(message)
        }
        return
      }
      _ = currentTestCase.perform(Selector(("recordIssue:")), with: issue)
    }

    /// This function generates a failure immediately and unconditionally.
    ///
    /// Dynamically calls `XCTFail` with the given file and line. Useful for defining assertion
    /// helpers that have the source code context at hand and want to highlight the direct caller
    /// of the helper.
    ///
    /// - Parameter message: An optional description of the assertion, for inclusion in test
    ///   results.
    @_disfavoredOverload
    public func XCTFail(_ message: String = "", file: StaticString, line: UInt) {
      let message = appendHostAppWarningIfNeeded(message)
      _XCTFailureHandler(nil, true, "\(file)", line, "\(message.isEmpty ? "failed" : message)", nil)
    }

    private typealias XCTFailureHandler = @convention(c) (
      AnyObject?, Bool, UnsafePointer<CChar>, UInt, String, String?
    ) -> Void
    private let _XCTFailureHandler = unsafeBitCast(
      dlsym(dlopen(nil, RTLD_LAZY), "_XCTFailureHandler"),
      to: XCTFailureHandler.self
    )
  #elseif canImport(XCTest)
    // NB: It seems to be safe to import XCTest on Linux
    @_exported import func XCTest.XCTFail
  #else
    @_disfavoredOverload
    public func XCTFail(_ message: String = "") {}
    @_disfavoredOverload
    public func XCTFail(_ message: String = "", file: StaticString, line: UInt) {}
  #endif

  func appendHostAppWarningIfNeeded(_ originalMessage: String) -> String {
    guard _XCTIsTesting else { return originalMessage }
    if Bundle.main.bundleIdentifier == "com.apple.dt.xctest.tool"  // Apple platforms
      || Bundle.main.bundleIdentifier == nil  // Linux
    {
      // XCTesting is providing a default host app.
      return originalMessage
    }

    if Thread.callStackSymbols.contains(where: { $0.range(of: "XCTestCore") != nil }) {
      // We are apparently performing a sync test
      return originalMessage
    }

    if testCaseSubclass(callStackSymbols: Thread.callStackSymbols) != nil {
      // We are apparently performing an async test.
      // We're matching a `() -> ()` function that starts with `test`, from a `XCTestCase` subclass
      return originalMessage
    }

    let message = """
      Warning! This failure occurred while running tests hosted by the main app.

      Testing using the main app as a host can lead to false positive test failures created by the \
      app accessing unimplemented values itself when it is spun up.

        - Test host: \(Bundle.main.bundleIdentifier ?? "Unknown")

      You can find more information and workarounds in the "Testing/Testing Gotchas" section of \
      Dependencies' documentation at \
      https://pointfreeco.github.io/swift-dependencies/main/documentation/dependencies/testing/.
      """

    return [originalMessage, "", message].joined(separator: "\n")
  }

  // (?<=\$s): Starts with "$s" (stable mangling);
  // \d{1,3}: Some numbers (the class name length or the module name length);
  // .*: The class name, or module name + class name length + class name;
  // C: The class type identifier;
  // (?=\d{1,3}test.*yy(Ya)?K?F): Followed by the function name length, function that starts with
  // `test`, has no arguments (y), returns Void (y), and is a function (F), potentially async (Ya),
  // throwing (K), or both.
  private let testCaseRegex = #"(?<=\$s)\d{1,3}.*C(?=\d{1,3}test.*yy(Ya)?K?F)"#

  func testCaseSubclass(callStackSymbols: [String]) -> Any.Type? {
    for frame in callStackSymbols {
      var startIndex = frame.startIndex
      while startIndex != frame.endIndex {
        if let range = frame.range(
          of: testCaseRegex,
          options: .regularExpression,
          range: startIndex..<frame.endIndex,
          locale: nil
        ) {
          if let testCase = testCase(mangledName: String(frame[range])) {
            return testCase
          }
          startIndex = range.upperBound
        } else {
          break
        }
      }
    }
    return nil
  }

  private func testCase(mangledName: String) -> Any.Type? {
    if let object = _typeByName(mangledName) as? NSObject.Type,
      NSClassFromString("XCTestCase").map(object.isSubclass(of:)) == true
    {
      return object
    }
    return nil
  }

#else
  /// This function generates a failure immediately and unconditionally.
  ///
  /// Dynamically creates and records an `XCTIssue` under the hood that captures the source code
  /// context of the caller. Useful for defining assertion helpers that fail in indirect code
  /// paths, where the `file` and `line` of the failure have not been realized.
  ///
  /// - Parameter message: An optional description of the assertion, for inclusion in test
  ///   results.
  @_disfavoredOverload
  public func XCTFail(_ message: String = "") {}

  /// This function generates a failure immediately and unconditionally.
  ///
  /// Dynamically creates and records an `XCTIssue` under the hood that captures the source code
  /// context of the caller. Useful for defining assertion helpers that fail in indirect code
  /// paths, where the `file` and `line` of the failure have not been realized.
  ///
  /// - Parameter message: An optional description of the assertion, for inclusion in test
  ///   results.
  @_disfavoredOverload
  public func XCTFail(_ message: String = "", file: StaticString, line: UInt) {}
#endif
