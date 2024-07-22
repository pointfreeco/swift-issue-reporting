extension IssueReporter where Self == FatalErrorReporter {
  /// An issue reporter that terminates program execution.
  ///
  /// Calls Swift's `fatalError` function when an issue is received.
  public static var fatalError: Self { Self() }
}

/// A type representing an issue reporter that terminates program execution.
///
/// Use ``IssueReporter/fatalError`` to create one of these values.
public struct FatalErrorReporter: IssueReporter {
  public func reportIssue(
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    var message = message() ?? ""
    if message.isEmpty {
      message = "Issue reported"
    }
    Swift.fatalError(message, file: filePath, line: line)
  }
}
