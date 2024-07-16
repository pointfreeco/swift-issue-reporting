#if canImport(Testing)
  import Testing
#endif

@_cdecl("IssueReportingTestSupport_RecordIssue")
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

@_cdecl("IssueReportingTestSupport_WithKnownIssue")
public func _withKnownIssue() -> Any { __withKnownIssue }
private func __withKnownIssue(
  _ message: String?,
  isIntermittent: Bool,
  _ body: () throws -> Void
) {
  #if canImport(Testing)
    withKnownIssue(message.map(Comment.init(rawValue:)), isIntermittent: isIntermittent, body)
  #endif
}

@_cdecl("IssueReportingTestSupport_CurrentTestIsNotNil")
public func _currentTestIsNotNil() -> Any { __currentTestIsNotNil }
private func __currentTestIsNotNil() -> Bool {
  #if canImport(Testing)
    return Test.current != nil
  #else
    return false
  #endif
}
