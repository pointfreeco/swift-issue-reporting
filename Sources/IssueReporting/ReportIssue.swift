/// Report an issue.
///
/// Invoking this function has two different behaviors depending on the context:
///
/// * When running your code in a non-testing context, this method will loop over the
/// collection of issue reports registered and invoke them. The default issue reporter for the
/// library is ``IssueReporter/runtimeWarning``, which emits a purple, runtime warning in Xcode:
///
///   ![A purple runtime warning in Xcode showing that an issue has been reported.](runtime-warning)
///
///   But you can there are also [other issue reports](<doc:GettingStarted#Issue-reporters>) you
///   can use, and you can create your own.
///
/// * When running your app in tests (both XCTest and Swift's native Testing framework), it will
/// emit a test failure. This allows you to get test coverage on your reported issues, both expected
/// and unexpected ones.
///
///   ![A test failure in Xcode where an issue has been reported.](test-failure)
///
/// [Issue.record]: https://developer.apple.com/documentation/testing/issue/record(_:sourcelocation:)
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

/// Report a caught error.
///
/// This function behaves similarly to ``reportIssue(_:fileID:filePath:line:column:)``, but for
/// reporting errors.
///
/// - Parameters:
///   - error: The error that caused the issue.
///   - message: A message describing the expectation.
///   - fileID: The source `#fileID` associated with the issue.
///   - filePath: The source `#filePath` associated with the issue.
///   - line: The source `#line` associated with the issue.
///   - column: The source `#column` associated with the issue.
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
      "Caught error: \(error)\(message().map { ": \($0)" } ?? "")".withAppHostWarningIfNeeded(),
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
