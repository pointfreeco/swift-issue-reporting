public struct IssueContext: Sendable {
  @TaskLocal public static var current: Self?

  public var fileID: StaticString
  public var filePath: StaticString
  public var line: UInt
  public var column: UInt

  public init(
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    self.fileID = fileID
    self.filePath = filePath
    self.line = line
    self.column = column
  }
}
