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
///   - fileID: The source `#fileID` associated with the issue.
///   - filePath: The source `#filePath` associated with the issue.
///   - line: The source `#line` associated with the issue.
///   - column: The source `#column` associated with the issue.
@_transparent
public func reportIssue(
  _ message: @autoclosure () -> String? = nil,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) {
  switch TestContext.current {
  case .swiftTesting:
    _recordIssue(
      message: message(),
      fileID: "\(IssueContext.current?.fileID ?? fileID)",
      filePath: "\(IssueContext.current?.filePath ?? filePath)",
      line: Int(IssueContext.current?.line ?? line),
      column: Int(IssueContext.current?.column ?? column)
    )
  case .xcTest:
    _XCTFail(
      message().withAppHostWarningIfNeeded() ?? "",
      file: IssueContext.current?.filePath ?? filePath,
      line: IssueContext.current?.line ?? line
    )
  case nil:
    guard !isTesting else { return }
    if let observer = FailureObserver.current {
      observer.withLock { $0 += 1 }
      for reporter in IssueReporters.current {
        reporter.expectIssue(
          message(),
          fileID: IssueContext.current?.fileID ?? fileID,
          filePath: IssueContext.current?.filePath ?? filePath,
          line: IssueContext.current?.line ?? line,
          column: IssueContext.current?.column ?? column
        )
      }
    } else {
      for reporter in IssueReporters.current {
        reporter.reportIssue(
          message(),
          fileID: IssueContext.current?.fileID ?? fileID,
          filePath: IssueContext.current?.filePath ?? filePath,
          line: IssueContext.current?.line ?? line,
          column: IssueContext.current?.column ?? column
        )
      }
    }
  }
}

@_transparent
public func reportIssue(
  _ error: any Error,
  _ message: @autoclosure () -> String? = nil,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) {
  switch TestContext.current {
  case .swiftTesting:
    _recordError(
      error: error,
      message: message(),
      fileID: "\(IssueContext.current?.fileID ?? fileID)",
      filePath: "\(IssueContext.current?.filePath ?? filePath)",
      line: Int(IssueContext.current?.line ?? line),
      column: Int(IssueContext.current?.column ?? column)
    )
  case .xcTest:
    _XCTFail(
      message().withAppHostWarningIfNeeded() ?? "",
      file: IssueContext.current?.filePath ?? filePath,
      line: IssueContext.current?.line ?? line
    )
  case nil:
    guard !isTesting else { return }
    if let observer = FailureObserver.current {
      observer.withLock { $0 += 1 }
      for reporter in IssueReporters.current {
        reporter.expectIssue(
          error,
          message(),
          fileID: IssueContext.current?.fileID ?? fileID,
          filePath: IssueContext.current?.filePath ?? filePath,
          line: IssueContext.current?.line ?? line,
          column: IssueContext.current?.column ?? column
        )
      }
    } else {
      for reporter in IssueReporters.current {
        reporter.reportIssue(
          error,
          message(),
          fileID: IssueContext.current?.fileID ?? fileID,
          filePath: IssueContext.current?.filePath ?? filePath,
          line: IssueContext.current?.line ?? line,
          column: IssueContext.current?.column ?? column
        )
      }
    }
  }
}
