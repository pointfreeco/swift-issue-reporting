#if canImport(XCTest)
  import XCTest
#endif

public func _XCTFail(_ message: String, file: StaticString, line: UInt) {
  #if canImport(XCTest)
    XCTFail(message, file: file, line: line)
  #endif
}

public func _XCTExpectFailure(
  _ failureReason: String?,
  strict: Bool?,
  failingBlock: () throws -> Void
) rethrows {
  #if canImport(XCTest)
    try XCTExpectFailure(failureReason, strict: strict, failingBlock: failingBlock)
  #endif
}
