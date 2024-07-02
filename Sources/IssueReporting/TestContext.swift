/// A type representing the context in which a test is being run.
public enum TestContext {
  /// The Swift Testing framework.
  case swiftTesting

  /// The XCTest framework.
  case xcTest
  
  /// The context associated with current test.
  ///
  /// How the test context is detected depends on the framework:
  ///
  ///   * If Swift Testing is running, _and_ this is called from the current task, this will return
  ///     ``swiftTesting``. In this way, `TestContext.current == .swiftTesting` is equivalent to
  ///     checking `Test.current != nil`, but safe to do from library and application code.
  ///
  ///   * If XCTest is running, _and_ this is called during the execution of a test _regardless_ of
  ///     task, this will return ``xcTest``.
  ///
  /// To detect if the current process is a test runner, use ``isTesting``, instead.
  public static var current: Self? {
    if Test.current != nil {
      return .swiftTesting
    } else if _XCTCurrentTestCase != nil {
      return .xcTest
    } else {
      return nil
    }
  }
}
