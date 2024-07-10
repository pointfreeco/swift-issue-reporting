#if canImport(Testing)
  import Testing
#endif

public func _recordIssue(
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

public func _withKnownIssue(
  _ message: String?,
  isIntermittent: Bool,
  _ body: () throws -> Void
) {
  #if canImport(Testing)
    withKnownIssue(message.map(Comment.init(rawValue:)), isIntermittent: isIntermittent, body)
  #endif
}

public func _testCurrentIsNotNil() -> Bool {
  #if canImport(Testing)
    return Test.current != nil
  #else
    return false
  #endif
}
