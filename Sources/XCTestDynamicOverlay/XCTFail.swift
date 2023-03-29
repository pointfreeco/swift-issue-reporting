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

      if !message.contains(where: \.isNewline) {
        message.append(" …")
      }

      message.append(
        """


        ━━┉┅
        Note: This failure was emitted from tests running in a host application\
        \(Bundle.main.bundleIdentifier.map { " (\($0))" } ?? "").

        This can lead to false positives, where failures could have emitted from live application \
        code at launch time, and not from the current test.

        For more information (and workarounds), see "Testing gotchas":

        https://pointfreeco.github.io/swift-dependencies/main/documentation/dependencies/testing#Testing-gotchas
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
        .map {
          (_typeByName(String(frame[$0])) as? NSObject.Type)?.isSubclass(of: XCTestCase) ?? false
        }
        ?? false
    }
  #elseif canImport(XCTest)
    // NB: It seems to be safe to import XCTest on Linux
    @_exported import func XCTest.XCTFail
  #else
    @_disfavoredOverload
    public func XCTFail(_ message: String = "") {
      print(noop(message: message))
    }
    @_disfavoredOverload
    public func XCTFail(_ message: String = "", file: StaticString, line: UInt) {
      print(noop(message: message, file: file, line: line))
    }
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
  public func XCTFail(_ message: String = "") {
    print(noop(message: message))
  }

  /// This function generates a failure immediately and unconditionally.
  ///
  /// Dynamically creates and records an `XCTIssue` under the hood that captures the source code
  /// context of the caller. Useful for defining assertion helpers that fail in indirect code
  /// paths, where the `file` and `line` of the failure have not been realized.
  ///
  /// - Parameter message: An optional description of the assertion, for inclusion in test
  ///   results.
  @_disfavoredOverload
  public func XCTFail(_ message: String = "", file: StaticString, line: UInt) {
    print(noop(message: message, file: file, line: line))
  }
#endif

private func noop(message: String, file: StaticString? = nil, line: UInt? = nil) -> String {
  let fileAndLine: String
//  let file: String? = "File.swift"
//  let line: Int? = 100
  if let file, let line {
    fileAndLine = """
      :
      ┃
      ┃   \(file):\(line)
      ┃
      ┃ …
      """
  } else {
    fileAndLine = "\n┃ "
  }

  return """
  XCTFail: \(message)

  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┉┅
  ┃ ⚠︎ Warning: This XCTFail was ignored
  ┃
  ┃ XCTFail was invoked in a non-DEBUG environment\(fileAndLine)and so was ignored. Be sure to run tests with
  ┃ the DEBUG=1 flag set in order to dynamically
  ┃ load XCTFail.
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┉┅
      ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄
  """
}
