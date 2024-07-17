#if canImport(XCTest)
  import XCTest
#endif

#if !os(Windows)
  @_cdecl("IssueReportingTestSupport_XCTFail")
#endif
public func _XCTFail() -> Any { __XCTFail }
private func __XCTFail(_ message: String, file: StaticString, line: UInt) {
  #if canImport(XCTest)
    XCTFail(message, file: file, line: line)
  #endif
}

#if !os(Windows)
  @_cdecl("IssueReportingTestSupport_XCTExpectFailure")
#endif
public func _XCTExpectFailure() -> Any { __XCTExpectFailure }
private func __XCTExpectFailure(
  _ failureReason: String?,
  strict: Bool?,
  failingBlock: () throws -> Void
) rethrows {
  #if canImport(XCTest)
    #if _runtime(_ObjC)
      try XCTExpectFailure(failureReason, strict: strict, failingBlock: failingBlock)
    #else
      XCTFail(
        """
        'XCTExpectFailure' is not available on this platform.

        Consider using Swift Testing and 'withKnownIssue', instead.
        """
      )
    #endif
  #endif
}
