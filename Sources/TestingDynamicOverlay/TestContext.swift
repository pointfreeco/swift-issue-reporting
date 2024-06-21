public enum TestContext {
  case swiftTesting
  case xcTest

  public static var current: Self? {
    if Test.current != nil {
      return .swiftTesting
    }
    if _XCTCurrentTestCase != nil {
      return .xcTest
    }
    return nil
  }
}
