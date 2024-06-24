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
    withKnownIssue(
      message,
      isIntermittent: isIntermittent,
      fileID: "\(IssueContext.current?.fileID ?? fileID)",
      filePath: "\(IssueContext.current?.filePath ?? filePath)",
      line: Int(IssueContext.current?.line ?? line),
      column: Int(IssueContext.current?.column ?? column),
      body
    )
  case .xcTest:
    XCTExpectFailure(
      message.withAppHostWarningIfNeeded(),
      strict: !isIntermittent,
      file: IssueContext.current?.filePath ?? filePath,
      line: IssueContext.current?.line ?? line
    ) {
      do {
        try body()
      } catch {
        XCTFail("Caught error: \(error)", file: filePath, line: line)
      }
    }
  case nil:
    guard !isTesting else { return }
    let observer = LockIsolated(FailureObserver())
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
        runtimeNote(
          "Caught error: \(error)",
          fileID: IssueContext.current?.fileID ?? fileID,
          line: IssueContext.current?.line ?? line
        )
      }
    }
    return
  }
}
