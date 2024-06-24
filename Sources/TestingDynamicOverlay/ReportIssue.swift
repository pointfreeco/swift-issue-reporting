/// Report an issue.
///
/// A generalized version of Swift Testing's [`Issue.record`][Issue.record] that emits "purple"
/// warnings to Xcode at runtime and logs fault-level messages to the console.
///
/// During test runs, the issue will be sent to Swift Testing's [`Issue.record`][Issue.record] _or_
/// XCTest's [`XCTFail`][XCTFail] accordingly, which means you can use it to drive custom assertion
/// helpers that you want to work in both Swift Testing and XCTest.
///
/// [Issue.record]: https://developer.apple.com/documentation/testing/issue/record(_:fileid:filepath:line:column:)
/// [XCTFail]: https://developer.apple.com/documentation/xctest/1500970-xctfail/
///
/// - Parameters:
///   - message: A message describing the issue.
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
      observer.withLock { $0.count += 1 }
      runtimeNote(
        message(),
        fileID: IssueContext.current?.fileID ?? fileID,
        line: IssueContext.current?.line ?? line
      )
    } else {
      runtimeWarn(
        message(),
        fileID: IssueContext.current?.fileID ?? fileID,
        line: IssueContext.current?.line ?? line
      )
    }
  }
}
