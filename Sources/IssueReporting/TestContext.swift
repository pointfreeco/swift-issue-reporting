/// A type representing the context in which a test is being run, i.e. either in Swift's native
/// Testing framework, or Xcode's XCTest framework.
public enum TestContext {
  /// The Swift Testing framework.
  case swiftTesting

  /// The XCTest framework.
  case xcTest

  // TODO: Fix docs
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
    guard isTesting else { return nil }
    if _currentTestIsNotNil() {
      return .swiftTesting
    } else {
      return .xcTest
    }
  }
}
