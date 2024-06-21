@_disfavoredOverload
@_transparent
public func withExpectedIssue(
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
