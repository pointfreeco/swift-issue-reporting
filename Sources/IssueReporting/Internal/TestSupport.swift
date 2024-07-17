import Foundation

#if os(WASI)
  import IssueReportingTestSupport
#elseif os(Windows)
  import WinSDK
#endif

@usableFromInline
func _recordIssue(
  message: String?,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int
) {
  #if os(WASI)
    let _recordIssue = _recordIssue()
  #else
    guard let _recordIssue = function(for: "IssueReportingTestSupport_RecordIssue")
    else { return }
  #endif
  let recordIssue = _recordIssue as! (String?, String, String, Int, Int) -> Void
  recordIssue(message, fileID, filePath, line, column)
}

@usableFromInline
func _withKnownIssue(
  _ message: String?,
  isIntermittent: Bool,
  _ body: () throws -> Void
) {
  #if os(WASI)
    let _withKnownIssue = _withKnownIssue()
  #else
    guard let _withKnownIssue = function(for: "IssueReportingTestSupport_WithKnownIssue")
    else { return }
  #endif
  let withKnownIssue = _withKnownIssue as! (String?, Bool, () throws -> Void) -> Void
  withKnownIssue(message, isIntermittent, body)
}


@usableFromInline
func _currentTestIsNotNil() -> Bool {
  #if os(WASI)
    let _currentTestIsNotNil = _currentTestIsNotNil()
  #else
    guard let _currentTestIsNotNil = function(for: "IssueReportingTestSupport_CurrentTestIsNotNil")
    else { return false }
  #endif
  let currentTestIsNotNil = _currentTestIsNotNil as! () -> Bool
  return currentTestIsNotNil()
}

@usableFromInline
func _XCTFail(_ message: String, file: StaticString, line: UInt) {
  #if os(WASI)
    let _XCTFail = _XCTFail()
  #else
    guard let _XCTFail = function(for: "IssueReportingTestSupport_XCTFail")
    else { return }
  #endif
  let XCTFail = _XCTFail as! (String, StaticString, UInt) -> Void
  XCTFail(message, file, line)
}

@usableFromInline
func _XCTExpectFailure(
  _ failureReason: String?,
  strict: Bool?,
  failingBlock: () throws -> Void
) rethrows {
  #if os(WASI)
    let _XCTExpectFailure = _XCTExpectFailure()
  #else
    guard let _XCTExpectFailure = function(for: "IssueReportingTestSupport_XCTExpectFailure")
    else { return }
  #endif
  let XCTExpectFailure = _XCTExpectFailure as! (String?, Bool?, () throws -> Void) throws -> Void
  try Result { try XCTExpectFailure(failureReason, strict, failingBlock) }._rethrowGet()
}

#if !os(WASI)
  #if os(Linux) || os(Windows)
    private typealias DynamicFunction = @convention(thin) () -> Any
  #else
    private typealias DynamicFunction = @convention(c) () -> Any
  #endif

  private func function(for symbol: String) -> Any? {
    #if os(Linux)
      let symbol = symbolMap[symbol] ?? symbol
      guard
        let handle = dlopen("libIssueReportingTestSupport.so", RTLD_LAZY),
        let pointer = dlsym(handle, symbol)
      else { return nil }
      return unsafeBitCast(pointer, to: DynamicFunction.self)()
    #elseif os(Windows)
      let symbol = symbolMap[symbol]
      guard
        let handle = LoadLibraryA("IssueReportingTestSupport.dll"),
        let pointer = GetProcAddress(handle, symbol)
      else { return nil }
      return unsafeBitCast(pointer, to: DynamicFunction.self)()
    #else
      guard
        let prefix,
        let path = Bundle.module
          .path(forResource: "\(prefix)_IssueReportingTestSupport", ofType: nil),
        let handle = dlopen(path, RTLD_LAZY),
        let pointer = dlsym(handle, symbol)
      else { return nil }
      return unsafeBitCast(pointer, to: DynamicFunction.self)()
    #endif
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

  #if os(Linux) || os(Windows)
    private let symbolMap: [String: String] = [
      "IssueReportingTestSupport_RecordIssue": "$s25IssueReportingTestSupport07_recordA0ypyF",
      "IssueReportingTestSupport_WithKnownIssue": "$s25IssueReportingTestSupport010_withKnownA0ypyF",
      "IssueReportingTestSupport_CurrentTestIsNotNil":
        "$s25IssueReportingTestSupport08_currentC8IsNotNilypyF",
      "IssueReportingTestSupport_XCTFail": "$s25IssueReportingTestSupport8_XCTFailypyF",
      "IssueReportingTestSupport_XCTExpectFailure":
        "$s25IssueReportingTestSupport17_XCTExpectFailureypyF",
    ]
  #endif
#endif
