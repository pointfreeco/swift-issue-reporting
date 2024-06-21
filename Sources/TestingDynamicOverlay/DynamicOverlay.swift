import Foundation

public let isTesting: Bool = {
  #if os(WASI)
    return false
  #else
    return ProcessInfo.processInfo.isTesting
  #endif
}()

public struct FailureContext: Sendable {
  @TaskLocal public static var current: Self?

  public var fileID: StaticString
  public var filePath: StaticString
  public var line: UInt
  public var column: UInt

  public init(
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    self.fileID = fileID
    self.filePath = filePath
    self.line = line
    self.column = column
  }
}

@_transparent
public func fail(
  _ message: @autoclosure () -> String = "",
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) {
  switch TestContext.current {
  case .swiftTesting:
    Issue.record(
      message(),
      fileID: "\(FailureContext.current?.fileID ?? fileID)",
      filePath: "\(FailureContext.current?.filePath ?? filePath)",
      line: Int(FailureContext.current?.line ?? line),
      column: Int(FailureContext.current?.column ?? column)
    )
  case .xcTest:
    XCTFail(
      message(),
      file: FailureContext.current?.filePath ?? filePath,
      line: FailureContext.current?.line ?? line
    )
  case nil:
    if let observer = FailureObserver.current {
      if observer.withLock({
        $0.count += 1
        return $0.precondition
      }) {
        runtimeNote(
          message(),
          fileID: FailureContext.current?.fileID ?? fileID,
          line: FailureContext.current?.line ?? line
        )
      }
    } else {
      runtimeWarn(
        message(),
        fileID: FailureContext.current?.fileID ?? fileID,
        line: FailureContext.current?.line ?? line
      )
    }
  }
}

@_transparent
public func withKnownFailure(
  _ message: String? = nil,
  isIntermittent: Bool = false,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  _ body: () throws -> Void,
  when precondition: () -> Bool = { true }
) {
  switch TestContext.current {
  case .swiftTesting:
    withKnownIssue(
      message,
      isIntermittent: isIntermittent,
      fileID: "\(FailureContext.current?.fileID ?? fileID)",
      filePath: "\(FailureContext.current?.filePath ?? filePath)",
      line: Int(FailureContext.current?.line ?? line),
      column: Int(FailureContext.current?.column ?? column),
      body,
      when: precondition
    )
  case .xcTest:
    XCTExpectFailure(
      message,
      enabled: precondition(),
      strict: !isIntermittent,
      file: FailureContext.current?.filePath ?? filePath,
      line: FailureContext.current?.line ?? line
    ) {
      do {
        try body()
      } catch {
        if precondition() {
          XCTFail("Caught error: \(error)", file: filePath, line: line)
        }
      }
    }
  case nil:
    let when = precondition()
    let observer = LockIsolated(FailureObserver(precondition: when))
    FailureObserver._$current.withValue(observer) {
      do {
        try body()
        if observer.withLock({ $0.count == 0 }), !isIntermittent {
          runtimeWarn(
            "Known issue was not recorded\(message.map { ": \($0)" } ?? "")",
            fileID: FailureContext.current?.fileID ?? fileID,
            line: FailureContext.current?.line ?? line
          )
        }
      } catch {
        if precondition() {
          runtimeNote(
            "Caught error: \(error)",
            fileID: FailureContext.current?.fileID ?? fileID,
            line: FailureContext.current?.line ?? line
          )
        }
      }
    }
    return
  }
}

public enum TestContext {
  case swiftTesting
  case xcTest

  public static var current: TestContext? {
    if Test.current != nil {
      return .swiftTesting
    }
    if _XCTCurrentTestCase != nil {
      return .xcTest
    }
    return nil
  }
}

private extension ProcessInfo {
  var isTesting: Bool {
    if environment.keys.contains("XCTestBundlePath") { return true }
    if environment.keys.contains("XCTestConfigurationFilePath") { return true }
    if environment.keys.contains("XCTestSessionIdentifier") { return true }
    if let argument = arguments.first {
      let path = URL(fileURLWithPath: argument)
      if path.lastPathComponent == "xctest" { return true }
    }
    if let argument = arguments.last {
      let path = URL(fileURLWithPath: argument)
      if path.pathExtension == "xctest" { return true }
    }
    return false
  }
}

@usableFromInline
struct FailureObserver {
  @usableFromInline
  @TaskLocal static var current: LockIsolated<Self>?
  @usableFromInline
  static var _$current: TaskLocal<LockIsolated<Self>?> { $current }
  @usableFromInline
  var count: Int
  @usableFromInline
  var precondition: Bool
  @usableFromInline
  init(count: Int = 0, precondition: Bool) {
    self.count = count
    self.precondition = precondition
  }
}
