import Foundation

#if DEBUG
  #if canImport(ObjectiveC)
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
      var message = message
      attachHostApplicationWarningIfNeeded(&message)
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
      var message = message
      attachHostApplicationWarningIfNeeded(&message)
      _XCTFailureHandler(nil, true, "\(file)", line, "\(message.isEmpty ? "failed" : message)", nil)
    }

    private typealias XCTFailureHandler = @convention(c) (
      AnyObject?, Bool, UnsafePointer<CChar>, UInt, String, String?
    ) -> Void
    private let _XCTFailureHandler = unsafeBitCast(
      dlsym(dlopen(nil, RTLD_LAZY), "_XCTFailureHandler"),
      to: XCTFailureHandler.self
    )

    private func attachHostApplicationWarningIfNeeded(_ message: inout String) {
      guard
        _XCTIsTesting,
        Bundle.main.bundleIdentifier != "com.apple.dt.xctest.tool"
      else { return }

      let callStack = Thread.callStackSymbols

      // Detect when synchronous test exists in stack.
      guard callStack.allSatisfy({ frame in !frame.contains("  XCTestCore ") })
      else { return }

      // Detect when asynchronous test exists in stack.
      guard callStack.allSatisfy({ frame in !isTestFrame(frame) })
      else { return }

      let displayName =
      Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
      ?? Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
      ?? "Unknown host application"

      let bundleIdentifier = Bundle.main.bundleIdentifier ?? "Unknown bundle identifier"

      message.append("""


        ┏━━━━━━━━━━━━━━━━━┉┅
        ┃ ⚠︎ Warning:
        ┃
        ┃ This failure was emitted from a host application outside the test stack.
        ┃
        ┃   Host application:
        ┃     \(displayName) (\(bundleIdentifier))
        ┃
        ┃ The host application may have emitted this failure when it first launched,
        ┃ outside of the current test that happened to be running.
        ┃
        ┃ Consider setting the test target's host application to "None," or prevent
        ┃ the host application from performing the code path that emits failure.
        ┗━━━━━━━━━━━━━━━━━┉┅

        For more information (and workarounds), see "Testing gotchas":

        https://pointfreeco.github.io/swift-dependencies/main/documentation/dependencies/testing#testing-gotchas
        """
      )
    }

    func isTestFrame(_ frame: String) -> Bool {
      // Regular expression to detect and demangle an XCTest case frame:
      //
      //  1. `(?<=\$s)`: Starts with "$s" (stable mangling)
      //  2. `\d{1,3}`: Some numbers (the class name length or the module name length)
      //  3. `.*`: The class name, or module name + class name length + class name
      //  4. `C`: The class type identifier
      //  5. `(?=\d{1,3}test.*yy(Ya)?K?F)`: The function name length, a function that starts with
      //     `test`, has no arguments (`y`), returns Void (`y`), and is a function (`F`), potentially
      //     async (`Ya`), throwing (`K`), or both.
      let mangledTestFrame = #"(?<=\$s)\d{1,3}.*C(?=\d{1,3}test.*yy(Ya)?K?F)"#

      guard let XCTestCase = NSClassFromString("XCTestCase")
      else { return false }

      return frame.range(of: mangledTestFrame, options: .regularExpression)
        .map { (_typeByName(String(frame[$0])) as? NSObject.Type)?.isSubclass(of: XCTestCase) ?? false }
        ?? false
    }
  #elseif canImport(XCTest)
    // NB: It seems to be safe to import XCTest on Linux
    @_exported import func XCTest.XCTFail
  #else
    @_disfavoredOverload
    public func XCTFail(_ message: String = "") {}
    @_disfavoredOverload
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
