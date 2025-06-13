/// Evaluates a value and reports an issue if it is nil.
///
/// - Parameters:
///   - value: The value to check for nil.
///   - message: A message describing the expectation.
///   - reporters: Issue reporters to notify if the value is nil.
///   - fileID: The source `#fileID` associated with the issue reporting.
///   - filePath: The source `#filePath` associated with the issue reporting.
///   - line: The source `#line` associated with the issue reporting.
///   - column: The source `#column` associated with the issue reporting.
/// - Returns: The optional value, unchanged.
@_transparent
public func reportIfNil<T>(
    _ value: T?,
    message: @autoclosure () -> String = "Unexpected nil value",
    to reporters: [any IssueReporter]? = nil,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column
) -> T? {
  
    guard let value else {
      withErrorReporting(
        message(),
        to: reporters,
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      ) {
        throw NilValueError()
      }
      return nil
    }
  
    return value
}

public struct NilValueError: Error {
  public init() {}
}
