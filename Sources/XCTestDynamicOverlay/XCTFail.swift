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
    public func XCTFail(_ message: String = "") {
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
        runtimeWarning(
          """
          "XCTFail" was invoked outside of a test.

            Message:
              %@

          This function should only be invoked during an XCTest run, and is a no-op when run in \
          application code. If you or a library you depend on is using "XCTFail" for test-specific \
          code paths, ensure that these same paths are not called in your application.
          """,
          [
            message.isEmpty ? "(none)" : message
          ]
        )
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
    public func XCTFail(_ message: String = "", file: StaticString, line: UInt) {
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
    public func XCTFail(_ message: String = "") {}
    public func XCTFail(_ message: String = "", file: StaticString, line: UInt) {}
  #endif
#else
  /// This function generates a failure immediately and unconditionally.
  ///
  /// Dynamically creates and records an `XCTIssue` under the hood that captures the source code
  /// context of the caller. Useful for defining assertion helpers that fail in indirect code
  /// paths, where the `file` and `line` of the failure have not been realized.
  ///
  /// - Parameter message: An optional description of the assertion, for inclusion in test
  ///   results.
  public func XCTFail(_ message: String = "") {}

  /// This function generates a failure immediately and unconditionally.
  ///
  /// Dynamically creates and records an `XCTIssue` under the hood that captures the source code
  /// context of the caller. Useful for defining assertion helpers that fail in indirect code
  /// paths, where the `file` and `line` of the failure have not been realized.
  ///
  /// - Parameter message: An optional description of the assertion, for inclusion in test
  ///   results.
  public func XCTFail(_ message: String = "", file: StaticString, line: UInt) {}
#endif
