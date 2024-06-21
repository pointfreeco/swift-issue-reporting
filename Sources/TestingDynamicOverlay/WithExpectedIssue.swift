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
      fileID: "\(IssueContext.current?.fileID ?? fileID)",
      filePath: "\(IssueContext.current?.filePath ?? filePath)",
      line: Int(IssueContext.current?.line ?? line),
      column: Int(IssueContext.current?.column ?? column),
      body,
      when: precondition
    )
  case .xcTest:
    XCTExpectFailure(
      message,
      enabled: precondition(),
      strict: !isIntermittent,
      file: IssueContext.current?.filePath ?? filePath,
      line: IssueContext.current?.line ?? line
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
            fileID: IssueContext.current?.fileID ?? fileID,
            line: IssueContext.current?.line ?? line
          )
        }
      } catch {
        if precondition() {
          runtimeNote(
            "Caught error: \(error)",
            fileID: IssueContext.current?.fileID ?? fileID,
            line: IssueContext.current?.line ?? line
          )
        }
      }
    }
    return
  }
}
