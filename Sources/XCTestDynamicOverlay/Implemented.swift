public final class _$Implemented: @unchecked Sendable {
  private let description: @Sendable () -> String
  private var fulfilled = false
  public init(_ description: @autoclosure @escaping @Sendable () -> String) {
    self.description = description
  }
  public func fulfill() {
    self.fulfilled = true
  }
  deinit {
    if !self.fulfilled {
      XCTFail("Uncalled: '\(self.description())'")
    }
  }
}
