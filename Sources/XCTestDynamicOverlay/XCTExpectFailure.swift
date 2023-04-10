import Foundation

#if DEBUG
  #if canImport(ObjectiveC)
    /// Instructs the test to expect a failure in an upcoming assertion, with options to customize expected failure checking and handling.
    /// - Parameters:
    ///   - failureReason: An optional string that describes why the test expects a failure.
    ///   - strict: A Boolean value that indicates whether the test reports an error if the expected failure doesn’t occur.
    ///   - failingBlock: A block of test code and assertions where the test expects a failure.
    @_transparent @_disfavoredOverload
    public func XCTExpectFailure(
      _ failureReason: String? = nil,
      strict: Bool = true,
      failingBlock: () -> Void
    ) {
      guard
        let XCTExpectedFailureOptions = NSClassFromString("XCTExpectedFailureOptions")
          as Any as? NSObjectProtocol,
        let options = strict
          ? XCTExpectedFailureOptions
            .perform(NSSelectorFromString("alloc"))?.takeUnretainedValue()
            .perform(NSSelectorFromString("init"))?.takeUnretainedValue()
          : XCTExpectedFailureOptions
            .perform(NSSelectorFromString("nonStrictOptions"))?.takeUnretainedValue()
      else { return }

      guard
        let functionBlockPointer = dlsym(
          dlopen(nil, RTLD_LAZY), "XCTExpectFailureWithOptionsInBlock")
      else {
        let errorString =
          dlerror().map { charPointer in
            String(cString: charPointer)
          } ?? "Unknown error"
        fatalError(
          "Failed to get symbol for XCTExpectFailureWithOptionsInBlock with error: \(errorString).")
      }

      let XCTExpectFailureWithOptionsInBlock = unsafeBitCast(
        functionBlockPointer,
        to: (@convention(c) (String?, AnyObject, () -> Void) -> Void).self
      )

      XCTExpectFailureWithOptionsInBlock(failureReason, options, failingBlock)
    }
  #elseif canImport(XCTest)
    // NB: It seems to be safe to import XCTest on Linux
    @_exported import func XCTest.XCTExpectFailure
  #else
    @_disfavoredOverload
    public func XCTExpectFailure(
      _ failureReason: String? = nil,
      strict: Bool = true,
      failingBlock: () -> Void
    ) {
      print(noop(message: failureReason))
    }
  #endif
#else

  /// Instructs the test to expect a failure in an upcoming assertion, with options to customize expected failure checking and handling.
  /// - Parameters:
  ///   - failureReason: An optional string that describes why the test expects a failure.
  ///   - strict: A Boolean value that indicates whether the test reports an error if the expected failure doesn’t occur.
  ///   - failingBlock: A block of test code and assertions where the test expects a failure.
  @_disfavoredOverload
  public func XCTExpectFailure(
    _ failureReason: String? = nil,
    strict: Bool = true,
    failingBlock: () -> Void
  ) {
    print(noop(message: failureReason))
  }
#endif

// Rule-of-threes: this is also used in XCTFail.swift. If you need it in a third place, consider refactoring.
private func noop(message: String?, file: StaticString? = nil, line: UInt? = nil) -> String {
  let fileAndLine: String
  if let file = file, let line = line {
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
    XCTExpectFailure: \(message ?? "<no message provided>")

    ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┉┅
    ┃ ⚠︎ Warning: This XCTExpectFailure was ignored
    ┃
    ┃ XCTExpectFailure was invoked in a non-DEBUG environment\(fileAndLine)and so was ignored. Be sure to run tests with
    ┃ the DEBUG=1 flag set in order to dynamically
    ┃ load XCTExpectFailure.
    ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┉┅
        ▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄
    """
}
