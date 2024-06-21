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
