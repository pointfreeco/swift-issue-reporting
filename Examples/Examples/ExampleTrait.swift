import IssueReporting

public struct ExampleTrait: Sendable {
  public init() {}

  public static func hasTrait() -> Bool {
    switch TestContext.current {
    case .none, .some(.xcTest):
      return false
    case .some(.swiftTesting(let testing)):
      return testing?.test.traits.contains { $0 is Self } ?? false
    }
  }
}
