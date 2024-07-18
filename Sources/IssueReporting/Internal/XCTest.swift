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
    // TODO: Warn
  #endif
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
    // TODO: Warn
    try failingBlock()
  #endif
}

public enum _XCTExpectedFailure {
  @TaskLocal public static var isInFailingBlock = false
}
