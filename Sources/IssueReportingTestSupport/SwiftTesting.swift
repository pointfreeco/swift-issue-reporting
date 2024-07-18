#if canImport(Testing)
  import Testing
#endif

#if !os(WASI) && !os(Windows)
  @_cdecl("IssueReportingTestSupport_RecordIssue")
#endif
public func _recordIssue() -> Any { __recordIssue }
private func __recordIssue(
  message: String?,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int
) {
  #if canImport(Testing)
    // NB: https://github.com/apple/swift-testing/issues/490
    // Issue.record(
    //   message.map(Comment.init(rawValue:)),
    //   sourceLocation: SourceLocation(
    //     fileID: fileID,
    //     filePath: filePath,
    //     line: line,
    //     column: column
    //   )
    // )
    __checkValue(
      false,
      expression: .__fromSyntaxNode(message ?? ""),
      comments: [],
      isRequired: false,
      sourceLocation: SourceLocation(
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
    )
    .__expected()
  #endif
}

#if !os(WASI) && !os(Windows)
  @_cdecl("IssueReportingTestSupport_WithKnownIssue")
#endif
public func _withKnownIssue() -> Any { __withKnownIssue }
private func __withKnownIssue(
  _ message: String?,
  isIntermittent: Bool,
  // TODO: fileID, filePath, ...
  _ body: () throws -> Void
) {
  #if canImport(Testing)
    withKnownIssue(message.map(Comment.init(rawValue:)), isIntermittent: isIntermittent, body)
  #endif
}

#if !os(WASI) && !os(Windows)
  @_cdecl("IssueReportingTestSupport_CurrentTestIsNotNil")
#endif
public func _currentTestIsNotNil() -> Any { __currentTestIsNotNil }
private func __currentTestIsNotNil() -> Bool {
  #if canImport(Testing)
    return Test.current != nil
  #else
    return false
  #endif
}
