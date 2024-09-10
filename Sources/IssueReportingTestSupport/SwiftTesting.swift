#if canImport(Testing)
  import Testing
#endif

public func _recordIssue() -> Any { __recordIssue }
@Sendable
private func __recordIssue(
  message: String?,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int
) {
  #if canImport(Testing)
    Issue.record(
      message.map(Comment.init(rawValue:)),
      sourceLocation: SourceLocation(
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
    )
  #endif
}

public func _recordError() -> Any { __recordError }
@Sendable
private func __recordError(
  error: any Error,
  message: String?,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int
) {
  #if canImport(Testing)
    Issue.record(
      error,
      message.map(Comment.init(rawValue:)),
      sourceLocation: SourceLocation(
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
    )
  #endif
}

public func _withKnownIssue() -> Any { __withKnownIssue }
@Sendable
private func __withKnownIssue(
  _ message: String?,
  isIntermittent: Bool,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int,
  _ body: () throws -> Void
) {
  #if canImport(Testing)
    withKnownIssue(
      message.map(Comment.init(rawValue:)),
      isIntermittent: isIntermittent,
      sourceLocation: SourceLocation(
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      ),
      body
    )
  #endif
}

public func _withKnownIssueAsync() -> Any { __withKnownIssueAsync }
@Sendable
private func __withKnownIssueAsync(
  _ message: String?,
  isIntermittent: Bool,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int,
  _ body: () async throws -> Void
) async {
  #if canImport(Testing)
    await withKnownIssue(
      message.map(Comment.init(rawValue:)),
      isIntermittent: isIntermittent,
      sourceLocation: SourceLocation(
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      ),
      body
    )
  #endif
}

public func _currentTestData() -> Any { __currentTestData }
@Sendable
private func __currentTestData() -> (id: AnyHashable, isParameterized: Bool)? {
  #if canImport(Testing)
    guard let id = Test.current?.id, let isParameterized = Test.Case.current?.isParameterized
    else { return nil }
    return (id, isParameterized)
  #else
    return nil
  #endif
}
