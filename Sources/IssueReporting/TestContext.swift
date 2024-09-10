/// A type representing the context in which a test is being run, _i.e._ either in Swift's native
/// Testing framework, or Xcode's XCTest framework.
public enum TestContext {
  /// The Swift Testing framework.
  case swiftTesting(Testing)

  /// The XCTest framework.
  case xcTest

  /// The context associated with current test.
  ///
  /// How the test context is detected depends on the framework:
  ///
  ///   * If Swift Testing is running, _and_ this is called from the current test's task, this will
  ///     return ``swiftTesting``. In this way, `TestContext.current == .swiftTesting` is equivalent
  ///     to checking `Test.current != nil`, but safe to do from library and application code.
  ///
  ///   * If XCTest is running, _and_ this is called during the execution of a test _regardless_ of
  ///     task, this will return ``xcTest``.
  ///
  /// If executed outside of a test process, this will return `nil`.
  public static var current: Self? {
    guard isTesting else { return nil }
    if case let (id, isParameterized)? = _currentTestData() {
      return .swiftTesting(Testing(id: id, isParameterized: isParameterized))
    } else {
      return .xcTest
    }
  }

  public struct Testing {
    public let test: Test

    public struct Test: Identifiable {
      public let id: ID
      public let `case`: Test.Case

      public struct Case {
        public let isParameterized: Bool
      }
      public struct ID: Hashable, @unchecked Sendable {
        fileprivate let rawValue: AnyHashable
      }
    }
  }
}

extension TestContext.Testing {
  fileprivate init(id: AnyHashable, isParameterized: Bool) {
    self.init(
      test: Test(
        id: Test.ID(rawValue: id),
        case: Test.Case(isParameterized: isParameterized)
      )
    )
  }
}
