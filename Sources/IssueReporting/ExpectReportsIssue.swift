/// A test helper for asserting against reported issues.
///
/// While Swift Testing's `withKnownIssue` can be used to soften known test failures from failing
/// the entire suite, the tool is not meant to be used to assert against _expected_ issues, and so
/// that is why IssueReporting provides `expectReportsIssue`.
///
/// - Parameters:
///   - message: An optional message describing the expected issue.
///   - fileID: The source `#fileID` associated with the expectation.
///   - filePath: The source `#filePath` associated with the expectation.
///   - line: The source `#line` associated with the expectation.
///   - column: The source `#column` associated with the expectation.
///   - body: The function to invoke.
///   - issueMatcher: A function to invoke when an issue is reported that is used to determine if
///     the issue is expected to occur.
@_transparent
public func expectReportsIssue(
  _ message: @autoclosure () -> String? = nil,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  _ body: () throws -> Void,
  matching issueMatcher: (_ issue: ReportedIssue) -> Bool
) rethrows {
  let issueReporter = ExpectationIssueReporter()
  try withIssueReporters([issueReporter], operation: body)
  let issues = issueReporter.issues.withLock({ $0 })
  guard !issues.isEmpty else {
    let message = message() ?? ""
    reportIssue(
      "Expected issue to be reported\(message.isEmpty ? "" : ": \(message)")",
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column
    )
    return
  }
  for issue in issues {
    guard issueMatcher(issue) else {
      reportIssue(
        "Issue does not match: \(issue.description)",
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
      continue
    }
  }
}

/// A test helper for asserting against reported issues.
///
/// An asynchronous version of `expectReportsIssue`.
///
/// - Parameters:
///   - message: An optional message describing the expected issue.
///   - fileID: The source `#fileID` associated with the expectation.
///   - filePath: The source `#filePath` associated with the expectation.
///   - line: The source `#line` associated with the expectation.
///   - column: The source `#column` associated with the expectation.
///   - body: The function to invoke.
///   - issueMatcher: A function to invoke when an issue is reported that is used to determine if
///     the issue is expected to occur.
@_transparent
nonisolated(nonsending)
  public func expectReportsIssue(
    _ message: @autoclosure () -> String? = nil,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    _ body: nonisolated (nonsending)() async throws -> Void,
    matching issueMatcher: (_ issue: ReportedIssue) -> Bool
  ) async rethrows
{
  let issueReporter = ExpectationIssueReporter()
  try await withIssueReporters([issueReporter], operation: body)
  let issues = issueReporter.issues.withLock({ $0 })
  guard !issues.isEmpty else {
    let message = message() ?? ""
    reportIssue(
      "Expected issue to be reported\(message.isEmpty ? "" : ": \(message)")",
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column
    )
    return
  }
  for issue in issues {
    guard issueMatcher(issue) else {
      reportIssue(
        "Issue does not match: ...\n\n\(issue.description))",
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
      continue
    }
  }
}

/// A type representing a reported issue.
///
/// Used to assert against issues reported by
/// ``expectReportsIssue(_:fileID:filePath:line:column:_:matching:)``.
///
public struct ReportedIssue: Sendable {
  /// A textual representation of this instance.
  public var description: String

  /// The error which was associated with this issue, if any.
  public var error: (any Error)?

  /// The severity of this issue.
  public var severity: IssueSeverity

  /// The `#fileID` in source where this issue occurred.
  public var fileID: StaticString

  /// The `#filePath` in source where this issue occurred.
  public var filePath: StaticString

  /// The `#line` in source where this issue occurred.
  public var line: UInt

  /// The `#column` in source where this issue occurred.
  public var column: UInt
}

@usableFromInline final class ExpectationIssueReporter: IssueReporter {
  @usableFromInline let issues = LockIsolated<[ReportedIssue]>([])
  @usableFromInline init() {}
  @usableFromInline func reportIssue(
    _ message: @autoclosure () -> String?,
    severity: IssueSeverity,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    let message = message() ?? ""
    issues.withLock {
      $0.append(
        ReportedIssue(
          description: "Issue reported\(message.isEmpty ? "" : ": \(message)")",
          severity: severity,
          fileID: fileID,
          filePath: filePath,
          line: line,
          column: column
        )
      )
    }
  }
}
