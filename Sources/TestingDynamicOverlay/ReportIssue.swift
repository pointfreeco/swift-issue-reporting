@_transparent
public func reportIssue(
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
      fileID: "\(IssueContext.current?.fileID ?? fileID)",
      filePath: "\(IssueContext.current?.filePath ?? filePath)",
      line: Int(IssueContext.current?.line ?? line),
      column: Int(IssueContext.current?.column ?? column)
    )
  case .xcTest:
    XCTFail(
      message().withAppHostWarningIfNeeded(),
      file: IssueContext.current?.filePath ?? filePath,
      line: IssueContext.current?.line ?? line
    )
  case nil:
    guard !isTesting else { return }
    if let observer = FailureObserver.current {
      if observer.withLock({
        $0.count += 1
        return $0.precondition
      }) {
        runtimeNote(
          message(),
          fileID: IssueContext.current?.fileID ?? fileID,
          line: IssueContext.current?.line ?? line
        )
      }
    } else {
      runtimeWarn(
        message(),
        fileID: IssueContext.current?.fileID ?? fileID,
        line: IssueContext.current?.line ?? line
      )
    }
  }
}
