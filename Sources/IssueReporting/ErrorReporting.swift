// swift-format-ignore-file
// Note: Whitespace changes are used to workaround compiler bug
// https://github.com/swiftlang/swift/issues/79285

/// Evaluates a throwing closure and automatically catches and reports any error thrown.
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
      } catch {
        reportIssue(
          error,
          message(),
          fileID: fileID,
          filePath: filePath,
          line: line,
          column: column
        )
        return nil
      }
    }
  } else {
    do {
      return try body()
    } catch {
      reportIssue(
        error,
        message(),
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
      return nil
    }
  }
}

#if compiler(>=6)
  /// Evaluates a throwing closure and automatically catches and reports any error thrown.
  ///
  /// - Parameters:
  ///   - message: A message describing the expectation.
  ///   - reporters: Issue reporters to notify during the operation.
  ///   - fileID: The source `#fileID` associated with the error reporting.
  ///   - filePath: The source `#filePath` associated with the error reporting.
  ///   - line: The source `#line` associated with the error reporting.
  ///   - column: The source `#column` associated with the error reporting.
  ///   - isolation: The isolation associated with the error reporting.
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
    isolation: isolated (any Actor)? = #isolation,
    // DO NOT FIX THE WHITESPACE IN THE NEXT LINE UNTIL 5.10 IS UNSUPPORTED
    // https://github.com/swiftlang/swift/issues/79285
    catching body: () async throws -> sending R) async -> R? {
    if let reporters {
      return await withIssueReporters(reporters) {
        do {
          return try await body()
        } catch {
          reportIssue(
            error,
            message(),
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column
          )
          return nil
        }
      }
    } else {
      do {
        return try await body()
      } catch {
        reportIssue(
          error,
          message(),
          fileID: fileID,
          filePath: filePath,
          line: line,
          column: column
        )
        return nil
      }
    }
  }
#else
  @_transparent
  @_unsafeInheritExecutor
  public func withErrorReporting<R>(
    _ message: @autoclosure () -> String? = nil,
    to reporters: [any IssueReporter]? = nil,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    catching body: () async throws -> R
  ) async -> R? {
    if let reporters {
      return await withIssueReporters(reporters) {
        do {
          return try await body()
        } catch {
          reportIssue(
            error,
            message(),
            fileID: fileID,
            filePath: filePath,
            line: line,
            column: column
          )
          return nil
        }
      }
    } else {
      do {
        return try await body()
      } catch {
        reportIssue(
          error,
          message(),
          fileID: fileID,
          filePath: filePath,
          line: line,
          column: column
        )
        return nil
      }
    }
  }
#endif
