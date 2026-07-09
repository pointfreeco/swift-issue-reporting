/// Evaluates a throwing closure and automatically catches and reports any error thrown.
///
/// Use this function to wrap a throwing unit of work for which you do not want to handle the
/// errors right now, but do want to be notified of the errors if they occur:
///
/// ```swift
/// withErrorReporting {
///   results = try JSONDecoder().decode([Item].self, from: data)
/// }
/// ```
///
/// - Parameters:
///   - message: A message describing the expectation.
///   - reporters: Issue reporters to notify during the operation.
///   - fileID: The source `#fileID` associated with the error reporting.
///   - filePath: The source `#filePath` associated with the error reporting.
///   - line: The source `#line` associated with the error reporting.
///   - column: The source `#column` associated with the error reporting.
///   - body: A synchronous operation.
/// - Returns: The optional result of the operation, or `nil` if an error was thrown.
@_transparent
public func withErrorReporting<R>(
  _ message: @autoclosure () -> String? = nil,
  to reporters: [any IssueReporter]? = nil,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  catching body: () throws -> R
) -> R? {
  if let reporters {
    return withIssueReporters(reporters) {
      do {
        return try body()
      } catch is CancellationError {
      } catch {
        reportIssue(
          error,
          message(),
          fileID: fileID,
          filePath: filePath,
          line: line,
          column: column
        )
      }
      return nil
    }
  } else {
    do {
      return try body()
    } catch is CancellationError {
    } catch {
      reportIssue(
        error,
        message(),
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
    }
    return nil
  }
}

/// Evaluates a throwing closure and automatically catches and reports any error thrown.
///
/// Use this function to wrap a throwing unit of work for which you do not want to handle the
/// errors right now, but do want to be notified of the errors if they occur:
///
/// ```swift
/// withErrorReporting {
///   results = try JSONDecoder().decode([Item].self, from: data)
/// }
/// ```
///
/// - Parameters:
///   - message: A message describing the expectation.
///   - reporters: Issue reporters to notify during the operation.
///   - fileID: The source `#fileID` associated with the error reporting.
///   - filePath: The source `#filePath` associated with the error reporting.
///   - line: The source `#line` associated with the error reporting.
///   - column: The source `#column` associated with the error reporting.
///   - body: A synchronous operation.
/// - Returns: The optional result of the operation, or `nil` if an error was thrown.
@_transparent
public func withErrorReporting<R>(
  _ message: @autoclosure () -> String? = nil,
  to reporters: [any IssueReporter]? = nil,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  catching body: () throws -> R?
) -> R? {
  (withErrorReporting(
    message(),
    to: reporters,
    fileID: fileID,
    filePath: filePath,
    line: line,
    column: column,
    catching: body
  ) as R??) ?? nil
}

/// Evaluates a throwing closure and automatically catches and reports any error thrown.
///
/// Use this function to wrap a throwing unit of work for which you do not want to handle the
/// errors right now, but do want to be notified of the errors if they occur:
///
/// ```swift
/// await withErrorReporting {
///   results = try await client.fetch()
/// }
/// ```
///
/// - Parameters:
///   - message: A message describing the expectation.
///   - reporters: Issue reporters to notify during the operation.
///   - fileID: The source `#fileID` associated with the error reporting.
///   - filePath: The source `#filePath` associated with the error reporting.
///   - line: The source `#line` associated with the error reporting.
///   - column: The source `#column` associated with the error reporting.
///   - body: An asynchronous operation.
/// - Returns: The optional result of the operation, or `nil` if an error was thrown.
@_transparent
public func withErrorReporting<R>(
  _ message: @autoclosure () -> String? = nil,
  to reporters: [any IssueReporter]? = nil,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  catching body: () async throws -> sending R
) async -> R? {
  if let reporters {
    return await withIssueReporters(reporters) {
      do {
        return try await body()
      } catch is CancellationError {
      } catch {
        reportIssue(
          error,
          message(),
          fileID: fileID,
          filePath: filePath,
          line: line,
          column: column
        )
      }
      return nil
    }
  } else {
    do {
      return try await body()
    } catch is CancellationError {
    } catch {
      reportIssue(
        error,
        message(),
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
    }
    return nil
  }
}

/// Evaluates a throwing closure and automatically catches and reports any error thrown.
///
/// Use this function to wrap a throwing unit of work for which you do not want to handle the
/// errors right now, but do want to be notified of the errors if they occur:
///
/// ```swift
/// await withErrorReporting {
///   results = try await client.fetch()
/// }
/// ```
///
/// - Parameters:
///   - message: A message describing the expectation.
///   - reporters: Issue reporters to notify during the operation.
///   - fileID: The source `#fileID` associated with the error reporting.
///   - filePath: The source `#filePath` associated with the error reporting.
///   - line: The source `#line` associated with the error reporting.
///   - column: The source `#column` associated with the error reporting.
///   - body: An asynchronous operation.
/// - Returns: The optional result of the operation, or `nil` if an error was thrown.
@_transparent
public func withErrorReporting<R>(
  _ message: @autoclosure () -> String? = nil,
  to reporters: [any IssueReporter]? = nil,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  catching body: () async throws -> sending R?
) async -> R? {
  (await withErrorReporting(
    message(),
    to: reporters,
    fileID: fileID,
    filePath: filePath,
    line: line,
    column: column,
    catching: body
  ) as R??) ?? nil
}
