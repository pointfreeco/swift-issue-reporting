// NB: Deprecated after 2.0.0

@_transparent
@available(
  *,
  deprecated,
  renamed: "expectReportsIssue",
  message: """
    Prefer 'expectReportsIssue' to assert against expected issues; to preserve 'withKnownIssue' soft failures, use '_withKnownIssue'
    """
)
public func withExpectedIssue(
  _ message: String? = nil,
  isIntermittent: Bool = false,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  _ body: () throws -> Void
) {
  _withKnownIssue(
    message,
    isIntermittent: isIntermittent,
    fileID: fileID,
    filePath: filePath,
    line: line,
    column: column,
    body
  )
}

#if compiler(>=6.0.2)
  @_transparent
  @available(
    *,
    deprecated,
    renamed: "expectReportsIssue",
    message: """
      Prefer 'expectReportsIssue' to assert against expected issues; to preserve 'withKnownIssue' soft failures, use '_withKnownIssue'
      """
  )
  public func withExpectedIssue(
    _ message: String? = nil,
    isIntermittent: Bool = false,
    isolation: isolated (any Actor)? = #isolation,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    _ body: _AsyncThrowingBody
  ) async {
    await _withKnownIssue(
      message,
      isIntermittent: isIntermittent,
      isolation: isolation,
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column,
      body
    )
  }
#else
  @_transparent
  @available(
    *,
    deprecated,
    renamed: "expectReportsIssue",
    message: """
      Prefer 'expectReportsIssue' to assert against expected issues; to preserve 'withKnownIssue' soft failures, use '_withKnownIssue'
      """
  )
  public func withExpectedIssue(
    _ message: String? = nil,
    isIntermittent: Bool = false,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    _ body: _AsyncThrowingBody
  ) async {
    await _withKnownIssue(
      message,
      isIntermittent: isIntermittent,
      fileID: fileID,
      filePath: filePath,
      line: line,
      column: column,
      body
    )
  }
#endif

#if compiler(>=6.4)
  @available(
    *,
    deprecated,
    message: """
      Prefer the 'nonisolated(nonsending)' overload with stricter execution on caller context semantics: withValue(_:operation:file:line:)
      """
  )
  public func withIssueContext<R>(
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt,
    isolation: isolated (any Actor)? = #isolation,
    operation: () async throws -> R
  ) async rethrows -> R {
    try await IssueContext.$current.withValue(
      IssueContext(fileID: fileID, filePath: filePath, line: line, column: column),
      operation: operation,
      isolation: isolation
    )
  }
#endif
