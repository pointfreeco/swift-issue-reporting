/// Sets the context for issues reported 
///
/// - Parameters:
///   - fileID: <#fileID description#>
///   - filePath: <#filePath description#>
///   - line: <#line description#>
///   - column: <#column description#>
///   - operation: <#operation description#>
/// - Throws: <#description#>
/// - Returns: <#description#>
public func withIssueContext<R>(
  fileID: StaticString,
  filePath: StaticString,
  line: UInt,
  column: UInt,
  operation: () throws -> R
) rethrows -> R {
  try IssueContext.$current.withValue(
    IssueContext(fileID: fileID, filePath: filePath, line: line, column: column),
    operation: operation
  )
}

public func withIssueContext<R>(
  fileID: StaticString,
  filePath: StaticString,
  line: UInt,
  column: UInt,
  operation: () async throws -> R
) async rethrows -> R {
  try await IssueContext.$current.withValue(
    IssueContext(fileID: fileID, filePath: filePath, line: line, column: column),
    operation: operation
  )
}

@usableFromInline
struct IssueContext: Sendable {
  @usableFromInline
  @TaskLocal static var current: Self?
  @usableFromInline
  let fileID: StaticString
  @usableFromInline
  let filePath: StaticString
  @usableFromInline
  let line: UInt
  @usableFromInline
  let column: UInt
}
