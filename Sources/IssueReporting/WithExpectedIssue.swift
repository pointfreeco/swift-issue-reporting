/// Invoke a function that has an issue that is expected to occur during its execution.
///
/// A generalized version of Swift Testing's [`withKnownIssue`][withKnownIssue] that works with this
/// library's [`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>) instead of just
/// Swift Testing's tools.
///
/// At runtime it can be used to lower the log level of reported issues:
///
/// ```swift
/// // Emits a "purple" warning to Xcode and logs a fault-level message to console
/// reportIssue("Failed")
///
/// withExpectedIssue {
///   // Simply logs an info-level message
///   reportIssue("Failed")
/// }
/// ```
///
/// During test runs, the issue will be sent to Swift Testing's [`withKnownIssue`][withKnownIssue]
/// _or_ XCTest's [`XCTExpectFailure`][XCTExpectFailure] accordingly, which means you can use it to
/// drive custom assertion helpers that you want to work in both Swift Testing and XCTest.
///
/// [withKnownIssue]: https://developer.apple.com/documentation/testing/withknownissue(_:isintermittent:fileid:filepath:line:column:_:)-30kgk
/// [XCTExpectFailure]: https://developer.apple.com/documentation/xctest/3727246-xctexpectfailure/
///
/// - Parameters:
///   - message: An optional message describing the known issue.
///   - isIntermittent: Whether or not the known issue occurs intermittently. If this argument is
///     `true` and the known issue does not occur, no secondary issue is recorded.
///   - fileID: The source `#fileID` associated with the issue.
///   - filePath: The source `#filePath` associated with the issue.
///   - line: The source `#line` associated with the issue.
///   - column: The source `#column` associated with the issue.
///   - body: The function to invoke.
@_transparent
public func withExpectedIssue(
  _ message: String? = nil,
  isIntermittent: Bool = false,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  _ body: () throws -> Void
) {
  switch TestContext.current {
  case .swiftTesting:
    _withKnownIssue(
      message,
      isIntermittent: isIntermittent,
      fileID: fileID.description,
      filePath: filePath.description,
      line: Int(line),
      column: Int(column),
      body
    )
  case .xcTest:
    _XCTExpectFailure(
      message.withAppHostWarningIfNeeded(),
      strict: !isIntermittent,
      file: filePath,
      line: line
    ) {
      do {
        try body()
      } catch {
        reportIssue(error, fileID: fileID, filePath: filePath, line: line, column: column)
      }
    }
  case nil:
    guard !isTesting else { return }
    let observer = FailureObserver()
    FailureObserver.$current.withValue(observer) {
      do {
        try body()
        if observer.withLock({ $0 == 0 }), !isIntermittent {
          for reporter in IssueReporters.current {
            reporter.reportIssue(
              "Known issue was not recorded\(message.map { ": \($0)" } ?? "")",
              fileID: IssueContext.current?.fileID ?? fileID,
              filePath: IssueContext.current?.filePath ?? filePath,
              line: IssueContext.current?.line ?? line,
              column: IssueContext.current?.column ?? column
            )
          }
        }
      } catch {
        for reporter in IssueReporters.current {
          reporter.expectIssue(
            error,
            nil,
            fileID: IssueContext.current?.fileID ?? fileID,
            filePath: IssueContext.current?.filePath ?? filePath,
            line: IssueContext.current?.line ?? line,
            column: IssueContext.current?.column ?? column
          )
        }
      }
    }
    return
  }
}
