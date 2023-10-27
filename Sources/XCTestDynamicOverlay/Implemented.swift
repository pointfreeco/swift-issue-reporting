public final class _$Implemented {
  private let description: () -> String
  private var fulfilled = false
  public init(_ description: @autoclosure @escaping () -> String) {
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
