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
func XCTFail(
  _ message: String = "",
  file: StaticString = #filePath,
  line: UInt = #line
) {
  guard
    !_XCTExpectedFailure.isInFailingBlock,
    let xctFailPtr
  else { return }
  withUnsafePointer(to: xctFailPtr) {
    let xctFail = UnsafeRawPointer($0).assumingMemoryBound(
      to: (@convention(thin) (String, StaticString, UInt) -> Void).self
    )
    .pointee
    xctFail(message, file, line)
  }
}

@_transparent
@usableFromInline
func XCTExpectFailure<R>(
  _ failureReason: String? = nil,
  enabled: Bool? = nil,
  strict: Bool? = nil,
  file: StaticString,
  line: UInt,
  failingBlock: () throws -> R
) rethrows -> R {
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
    XCTFail("XCTExpectFailure is unavailable", file: file, line: line)
    return try _XCTExpectedFailure.$isInFailingBlock.withValue(true) {
      try failingBlock()
    }
  #endif
}

public enum _XCTExpectedFailure {
  @TaskLocal public static var isInFailingBlock = false
}

@rethrows
@usableFromInline
protocol _ErrorMechanism {
  associatedtype Output
  func get() throws -> Output
}
extension _ErrorMechanism {
  func _rethrowError() rethrows -> Never {
    _ = try _rethrowGet()
    fatalError()
  }
  @usableFromInline
  func _rethrowGet() rethrows -> Output {
    return try get()
  }
}
extension Result: _ErrorMechanism {}

var _XCTCurrentTestCase: AnyObject? {
  #if _runtime(_ObjC)
    guard
      let xcTestObservationCenter = NSClassFromString("XCTestObservationCenter"),
      let xcTestObservationCenter = xcTestObservationCenter as Any as? NSObjectProtocol,
      let shared = xcTestObservationCenter.perform(Selector(("sharedTestObservationCenter")))?
        .takeUnretainedValue(),
      let observers = shared.perform(Selector(("observers")))?
        .takeUnretainedValue() as? [AnyObject],
      let observer =
        observers
        .first(where: { NSStringFromClass(type(of: $0)) == "XCTestMisuseObserver" }),
      let currentTestCase = observer.perform(Selector(("currentTestCase")))?
        .takeUnretainedValue()
    else { return nil }
    return currentTestCase
  #else
    // NB: swift-corelibs-xctest doesn't provide a public symbol to detect if we're in a test, so we
    //     always consider ourselves in a test if XCTest is linked.
    if xctFailPtr != nil {
      class Object {}
      return Object()
    }
    return nil
  #endif
}

private var xctFailPtr: UnsafeMutableRawPointer? {
  let mangledXctFail = "$s6XCTest7XCTFail_4file4lineySS_s12StaticStringVSutF"
  #if canImport(Darwin) || canImport(Glibc)
    return dlsym(
      dlopen("libXCTest.so", RTLD_NOW) ?? dlopen(nil, RTLD_NOW),
      mangledXctFail
    )
  #elseif canImport(WinSDK)
    guard let dll = LoadLibraryA("XCTest.dll") else { return nil }
    return GetProcAddress(dll, mangledXctFail)
  #else
    return nil
  #endif
}
