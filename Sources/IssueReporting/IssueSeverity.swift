/// The severity of an issue reported by ``reportIssue(_:severity:fileID:filePath:line:column:)``.
public enum IssueSeverity: Sendable {
  case warning
  case error
}
