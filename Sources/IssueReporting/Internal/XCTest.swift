#if _runtime(_ObjC)
  import Foundation
#endif

#if canImport(Darwin)
  import Darwin
#elseif canImport(Glibc)
  import Glibc
#elseif canImport(WinSDK)
  import WinSDK
#endif

@usableFromInline
func _XCTFail(
  _ message: String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) {
  guard let function = function(for: .xctFail)
  else {
    #if DEBUG
      var pointer: UnsafeMutableRawPointer? {
        let symbol = "$s6XCTest7XCTFail_4file4lineySS_s12StaticStringVSutF"
        #if canImport(Darwin) || canImport(Glibc)
          return dlsym(dlopen("libXCTest.so", RTLD_NOW) ?? dlopen(nil, RTLD_NOW), symbol)
        #elseif canImport(WinSDK)
          guard let dll = LoadLibraryA("XCTest.dll") else { return nil }
          return GetProcAddress(dll, symbol)
        #else
          return nil
        #endif
      }

      guard
        !_XCTExpectedFailure.isInFailingBlock,
        let pointer
      else { return }
      let XCTFail = unsafeBitCast(
        pointer,
        to: (@convention(thin) (String, StaticString, UInt) -> Void).self
      )
      XCTFail(message, file, line)
    #else
      fputs("""
        \(file):\(line): A failure was recorded without linking the XCTest framework.
        
        To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
        """,
        stderr
      )
    #endif
    return
  }

  let XCTFail = function as! @Sendable (String, StaticString, UInt) -> Void
  XCTFail(message, file, line)
}

@_transparent
@usableFromInline
func _XCTExpectFailure<R>(
  _ failureReason: String? = nil,
  enabled: Bool? = nil,
  strict: Bool? = nil,
  file: StaticString,
  line: UInt,
  failingBlock: () throws -> R
) rethrows -> R {
  guard let function = function(for: .xctExpectFailure)
  else {
    #if DEBUG
      guard enabled != false
      else {
        return try failingBlock()
      }
      #if _runtime(_ObjC)
        guard
          let xctExpectFailureInBlockPtr = dlsym(
            dlopen(nil, RTLD_NOW),
            "XCTExpectFailureWithOptionsInBlock"
          ),
          let xctExpectedFailureOptions = NSClassFromString("XCTExpectedFailureOptions")
            as Any as? NSObjectProtocol,
          let options = strict ?? true
            ? xctExpectedFailureOptions
              .perform(NSSelectorFromString("alloc"))?.takeUnretainedValue()
              .perform(NSSelectorFromString("init"))?.takeUnretainedValue()
            : xctExpectedFailureOptions
              .perform(NSSelectorFromString("nonStrictOptions"))?.takeUnretainedValue()
        else {
          return try failingBlock()
        }
        let xctExpectFailureInBlock = unsafeBitCast(
          xctExpectFailureInBlockPtr,
          to: (@convention(c) (String?, AnyObject, () -> Void) -> Void).self
        )
        var result: Result<R, any Error>!
        xctExpectFailureInBlock(failureReason, options) {
          result = Result { try failingBlock() }
        }
        return try result._rethrowGet()
      #else
        _XCTFail(
          "XCTest's XCTExpectFailure is unavailable on this platform.",
          file: file,
          line: line
        )
        return try _XCTExpectedFailure.$isInFailingBlock.withValue(true) {
          try failingBlock()
        }
      #endif
    #else
      fputs("""
        \(file):\(line): An expected failure was recorded without linking the XCTest framework.
        
        To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
        """,
        stderr
      )
      return try failingBlock()
    #endif
  }

  let XCTExpectFailure = function as! @Sendable (String?, Bool?, Bool?, () throws -> Void) throws -> Void
  var result: Result<R, any Error>!
  do {
    try XCTExpectFailure(failureReason, enabled, strict) {
      result = Result { try failingBlock() }
    }
  } catch {
    fatalError()
  }
  return try result._rethrowGet()
}

public enum _XCTExpectedFailure {
  @TaskLocal public static var isInFailingBlock = false
}