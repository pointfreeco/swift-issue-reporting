import Foundation

#if os(WASI) && DEBUG
  #if canImport(Testing)
    import Testing
  #endif
  #if canImport(XCTest)
    import XCTest
  #endif
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
    #if canImport(Testing) && DEBUG
      // NB: https://github.com/apple/swift-testing/issues/490
      // Issue.record(
      //   message.map(Comment.init(rawValue:)),
      //   sourceLocation: SourceLocation(
      //     fileID: fileID,
      //     filePath: filePath,
      //     line: line,
      //     column: column
      //   )
      // )
      __checkValue(
        false,
        expression: .__fromSyntaxNode(message ?? ""),
        comments: [],
        isRequired: false,
        sourceLocation: SourceLocation(
          fileID: fileID,
          filePath: filePath,
          line: line,
          column: column
        )
      )
      .__expected()
    #endif
  #else
    guard let _recordIssue = function(for: "IssueReportingTestSupport_RecordIssue")
    else { return }
    let recordIssue = _recordIssue as! (String?, String, String, Int, Int) -> Void
    recordIssue(message, fileID, filePath, line, column)
  #endif
}

@usableFromInline
func _withKnownIssue(
  _ message: String?,
  isIntermittent: Bool,
  _ body: () throws -> Void
) {
  #if os(WASI)
    #if canImport(Testing) && DEBUG
      withKnownIssue(message.map(Comment.init(rawValue:)), isIntermittent: isIntermittent, body)
    #endif
  #else
    guard let _withKnownIssue = function(for: "IssueReportingTestSupport_WithKnownIssue")
    else { return }
    let withKnownIssue = _withKnownIssue as! (String?, Bool, () throws -> Void) -> Void
    withKnownIssue(message, isIntermittent, body)
  #endif
}

@usableFromInline
func _currentTestIsNotNil() -> Bool {
  #if os(WASI)
    #if canImport(Testing) && DEBUG
      return Test.current != nil
    #else
      return false
    #endif
  #else
    guard let _currentTestIsNotNil = function(for: "IssueReportingTestSupport_CurrentTestIsNotNil")
    else { return false }
    let currentTestIsNotNil = _currentTestIsNotNil as! () -> Bool
    return currentTestIsNotNil()
  #endif
}

@usableFromInline
func _XCTFail(_ message: String, file: StaticString, line: UInt) {
  #if os(WASI)
    #if canImport(XCTest) && DEBUG
      XCTFail(message, file: file, line: line)
    #endif
  #else
    guard let _XCTFail = function(for: "IssueReportingTestSupport_XCTFail")
    else { return }
    let XCTFail = _XCTFail as! (String, StaticString, UInt) -> Void
    XCTFail(message, file, line)
  #endif
}

@usableFromInline
func _XCTExpectFailure(
  _ failureReason: String?,
  strict: Bool?,
  failingBlock: () throws -> Void
) rethrows {
  #if os(WASI)
    #if canImport(XCTest) && DEBUG
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
  #else
    guard let _XCTExpectFailure = function(for: "IssueReportingTestSupport_XCTExpectFailure")
    else { return }
    let XCTExpectFailure = _XCTExpectFailure as! (String?, Bool?, () throws -> Void) throws -> Void
    try Result { try XCTExpectFailure(failureReason, strict, failingBlock) }._rethrowGet()
  #endif
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
      "IssueReportingTestSupport_WithKnownIssue":
        "$s25IssueReportingTestSupport010_withKnownA0ypyF",
      "IssueReportingTestSupport_CurrentTestIsNotNil":
        "$s25IssueReportingTestSupport08_currentC8IsNotNilypyF",
      "IssueReportingTestSupport_XCTFail": "$s25IssueReportingTestSupport8_XCTFailypyF",
      "IssueReportingTestSupport_XCTExpectFailure":
        "$s25IssueReportingTestSupport17_XCTExpectFailureypyF",
    ]
  #endif
#endif
