import Foundation

@usableFromInline
func _recordIssue(
  message: String?,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int
) {
  guard let pointer = pointer(for: "IssueReportingTestSupport_RecordIssue")
  else { fatalError() }

  let recordIssue = withUnsafePointer(to: pointer) {
    UnsafeRawPointer($0).assumingMemoryBound(
      to: (@convention(c) () -> Any).self
    )
  }
  .pointee() as! (String?, String, String, Int, Int) -> Void

  recordIssue(message, fileID, filePath, line, column)
}

@usableFromInline
func _withKnownIssue(
  _ message: String?,
  isIntermittent: Bool,
  _ body: () throws -> Void
) {
  guard let pointer = pointer(for: "IssueReportingTestSupport_WithKnownIssue")
  else { fatalError() }

  let withKnownIssue = withUnsafePointer(to: pointer) {
    UnsafeRawPointer($0).assumingMemoryBound(
      to: (@convention(c) () -> Any).self
    )
  }
  .pointee() as! (String?, Bool, () throws -> Void) -> Void

  withKnownIssue(message, isIntermittent, body)
}


@usableFromInline
func _currentTestIsNotNil() -> Bool {
  guard let pointer = pointer(for: "IssueReportingTestSupport_CurrentTestIsNotNil")
  else { fatalError() }

  let currentTestIsNotNil = withUnsafePointer(to: pointer) {
    UnsafeRawPointer($0).assumingMemoryBound(
      to: (@convention(c) () -> Any).self
    )
  }
  .pointee() as! () -> Bool

  return currentTestIsNotNil()
}

@usableFromInline
func _XCTFail(_ message: String, file: StaticString, line: UInt) {
  guard let pointer = pointer(for: "IssueReportingTestSupport_XCTFail")
  else { fatalError() }

  let XCTFail = withUnsafePointer(to: pointer) {
    UnsafeRawPointer($0).assumingMemoryBound(
      to: (@convention(c) () -> Any).self
    )
  }
  .pointee() as! (String, StaticString, UInt) -> Void

  XCTFail(message, file, line)
}

@usableFromInline
func _XCTExpectFailure(
  _ failureReason: String?,
  strict: Bool?,
  failingBlock: () throws -> Void
) rethrows {
  guard let pointer = pointer(for: "IssueReportingTestSupport_XCTExpectFailure")
  else { fatalError() }

  let XCTExpectFailure = withUnsafePointer(to: pointer) {
    UnsafeRawPointer($0).assumingMemoryBound(
      to: (@convention(c) () -> Any).self
    )
  }
  .pointee() as! (String?, Bool?, () throws -> Void) throws -> Void

  // TODO: Traffic `rethrows`
  try? XCTExpectFailure(failureReason, strict, failingBlock)
}

private func pointer(for symbol: String) -> UnsafeMutableRawPointer? {
  guard
    let prefix,
    let path = Bundle.module
      .path(forResource: "\(prefix)_IssueReportingTestSupport", ofType: nil),
    let handle = dlopen(path, RTLD_LAZY),
    let pointer = dlsym(handle, symbol)
  else { return nil }
  return pointer
}

private let prefix: String? = {
  #if targetEnvironment(macCatalyst)
    return "ios-arm64_x86_64-maccatalyst"
  #elseif os(iOS)
    #if targetEnvironment(simulator)
      return "ios-arm64_x86_64-simulator"
    #else
      return "ios-arm64"
    #endif
  #elseif os(macOS)
    return "macos-arm64_x86_64"
  #elseif os(tvOS)
    #if targetEnvironment(simulator)
      return "tvos-arm64_x86_64-simulator"
    #else
      return "tvos-arm64"
    #endif
  #elseif os(visionOS)
    #if targetEnvironment(simulator)
      return "xros-arm64_x86_64-simulator"
    #else
      return "xros-arm64"
    #endif
  #elseif os(watchOS)
    #if targetEnvironment(simulator)
      return "watchos-arm64_x86_64-simulator"
    #else
      return "watchos-arm64_arm64_32_armv7k"
    #endif
  #else
    return nil
  #endif
}()
