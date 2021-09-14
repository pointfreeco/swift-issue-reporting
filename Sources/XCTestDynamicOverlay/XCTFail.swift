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
        let XCTestObservationCenter = NSClassFromString("XCTestObservationCenter")
          as Any as? NSObjectProtocol,
        String(describing: XCTestObservationCenter) != "<null>",
        let shared = XCTestObservationCenter.perform(Selector(("sharedTestObservationCenter")))?
          .takeUnretainedValue(),
        let observers = shared.perform(Selector(("observers")))?
          .takeUnretainedValue() as? [AnyObject],
        let observer =
          observers
          .first(where: { NSStringFromClass(type(of: $0)) == "XCTestMisuseObserver" }),
        let currentTestCase = observer.perform(Selector(("currentTestCase")))?
          .takeUnretainedValue(),
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
        #if canImport(Darwin)
          let indentedMessage = message.split(separator: "\n", omittingEmptySubsequences: false)
            .map { "  \($0)" }
            .joined(separator: "\n")

          breakpoint(
            """
            ---
            Warning: "XCTestDynamicOverlay.XCTFail" has been invoked outside of tests\
            \(message.isEmpty ? "." : "with the message:\n\n\(indentedMessage)")

            This function should only be invoked during an XCTest run, and is a no-op when run in \
            application code. If you or a library you depend on is using "XCTFail" for \
            test-specific code paths, ensure that these same paths are not called in your \
            application.
            ---
            """
          )
        #endif
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
      guard let _XCTFailureHandler = _XCTFailureHandler
      else { return }

      _XCTFailureHandler(nil, true, "\(file)", line, "\(message.isEmpty ? "failed" : message)", nil)
    }

    private typealias XCTFailureHandler = @convention(c) (
      AnyObject?, Bool, UnsafePointer<CChar>, UInt, String, String?
    ) -> Void
    private let XCTest = NSClassFromString("XCTest")
      .flatMap(Bundle.init(for:))
      .flatMap { $0.executablePath }
      .flatMap { dlopen($0, RTLD_NOW) }
    private let _XCTFailureHandler =
      XCTest
      .flatMap { dlsym($0, "_XCTFailureHandler") }
      .map { unsafeBitCast($0, to: XCTFailureHandler.self) }
  #else
    // NB: It seems to be safe to import XCTest on Linux
    @_exported import func XCTest.XCTFail
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
