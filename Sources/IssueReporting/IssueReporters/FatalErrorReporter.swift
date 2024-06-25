extension IssueReporter where Self == FatalErrorReporter {
  public static var fatalError: Self { Self() }
}

public struct FatalErrorReporter: IssueReporter {
  public func reportIssue(
    _ message: @autoclosure () -> String,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    Swift.fatalError(message(), file: filePath, line: line)
  }
}
