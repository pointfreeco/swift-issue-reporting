import Foundation

public struct XCTFailContext: Sendable {
  @TaskLocal public static var current: Self?

  public var file: StaticString
  public var line: UInt

  public init(file: StaticString, line: UInt) {
    self.file = file
    self.line = line
  }
}

#if canImport(ObjectiveC)
  /// This function generates a failure immediately and unconditionally.
  ///
  /// Dynamically creates and records an `XCTIssue` under the hood that captures the source code
  /// context of the caller. Useful for defining assertion helpers that fail in indirect code paths,
  /// where the `file` and `line` of the failure have not been realized.
  ///
  /// - Parameter message: An optional description of the assertion, for inclusion in test results.
  @_disfavoredOverload
  public func XCTFail(_ message: String = "") {
    if let context = XCTFailContext.current {
      XCTFail(message, file: context.file, line: context.line)
      return
    }
    var message = message
    attachHostApplicationWarningIfNeeded(&message)
    guard
      let currentTestCase = XCTCurrentTestCase,
      let issue = (NSClassFromString("XCTIssue") as Any as? NSObjectProtocol)?
        .perform(NSSelectorFromString("alloc"))?.takeUnretainedValue()
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
    if let testFrame = Thread.callStackSymbols.enumerated().first(where: { isTestFrame($1) }),
      let sourceCodeContext =
        (NSClassFromString("XCTSourceCodeContext") as Any as? NSObjectProtocol)?
        .perform(NSSelectorFromString("alloc"))?.takeUnretainedValue()
        .perform(
          Selector(("initWithCallStackAddresses:location:")),
          with: Array(Thread.callStackReturnAddresses[testFrame.offset...]),
          with: nil
        )?
        .takeUnretainedValue()
    {
      _ = issue.perform(Selector(("setSourceCodeContext:")), with: sourceCodeContext)
    }
    _ = currentTestCase.perform(Selector(("recordIssue:")), with: issue)
  }

  /// This function generates a failure immediately and unconditionally.
  ///
  /// Dynamically calls `XCTFail` with the given file and line. Useful for defining assertion
  /// helpers that have the source code context at hand and want to highlight the direct caller of
  /// the helper.
  ///
  /// - Parameter message: An optional description of the assertion, for inclusion in test results.
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
#else
  private typealias XCTFailType = (_: String, _ file: StaticString, _ line: UInt) -> Void
  private func unsafeCastToXCTFailType(_ pXCTFail: UnsafeRawPointer) -> XCTFailType {
    // NB: The function itself is a Swift function and must be marked as
    // `__attribute__((__swiftcall__))`. However, translating the Swift signature
    // `(_:file:line:) -> ()` to C is slightly tricky as we cannot guarantee the formal parameter
    // set matches the actual ABI of the function. Work around this by exploiting some undefined
    // behavior. Take a pointer to the raw pointer, cast the pointee to the appropriate Swift
    // signature, and then return the pointee.  Given that the pointer itself is to a `.text`
    // location which should not be unmapped, we should be able to deal with the escaping pointer
    // remaining valid for the lifetime of the application. Unloading dynamically linked libraries
    // is fraught with peril, and is generally unsupported.
    withUnsafePointer(to: pXCTFail) {
      UnsafeRawPointer($0).assumingMemoryBound(
        to: (@convention(thin) (
          _: String,
          _: StaticString,
          _: UInt
        ) -> Void).self
      ).pointee
    }
  }

  #if os(Windows)
    import WinSDK

    private func ResolveXCTFail() -> XCTFailType? {
      let hXCTest = LoadLibraryA("XCTest.dll")
      guard let hXCTest else { return nil }

      if let pXCTFail = GetProcAddress(
        hXCTest,
        "$s6XCTest7XCTFail_4file4lineySS_s12StaticStringVSutF"
      ) {
        return unsafeCastToXCTFailType(unsafeBitCast(pXCTFail, to: UnsafeRawPointer.self))
      }

      return nil
    }
  #else
    import Glibc

    private func ResolveXCTFail() -> XCTFailType? {
      var hXCTest = dlopen("libXCTest.so", RTLD_NOW)
      if hXCTest == nil { hXCTest = dlopen(nil, RTLD_NOW) }

      if let pXCTFail = dlsym(hXCTest, "$s6XCTest7XCTFail_4file4lineySS_s12StaticStringVSutF") {
        return unsafeCastToXCTFailType(pXCTFail)
      }

      return nil
    }
  #endif

  enum DynamicallyResolved {
    static let XCTFail = {
      if let XCTFail = ResolveXCTFail() {
        return { (message: String, file: StaticString, line: UInt) in
          XCTFail(message, file, line)
        }
      }
      return { (message: String, _ file: StaticString, _ line: UInt) in
        print(noop(message: message))
      }
    }()
  }

  @_disfavoredOverload
  public func XCTFail(_ message: String = "", file: StaticString = #file, line: UInt = #line) {
    DynamicallyResolved.XCTFail(message, file, line)
  }
#endif

private func noop(message: String, file: StaticString? = nil, line: UInt? = nil) -> String {
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
