/// A type representing the context in which a test is being run, _i.e._ either in Swift's native
/// Testing framework, or Xcode's XCTest framework.
public enum TestContext: Equatable, Sendable {
  /// The Swift Testing framework.
  case swiftTesting(Testing?)

  /// The XCTest framework.
  case xcTest

  /// The context associated with current test.
  ///
  /// How the test context is detected depends on the framework:
  ///
  ///   * If Swift Testing is running, _and_ this is called from the current test's task, this will
  ///     return ``swiftTesting`` with an associated value of the current test. You can invoke
  ///     ``isSwiftTesting`` to detect if the test is currently in the Swift Testing framework,
  ///     which is equivalent to checking `Test.current != nil`, but safe to do from library and
  ///     application code.
  ///
  ///   * If XCTest is running, _and_ this is called during the execution of a test _regardless_ of
  ///     task, this will return ``xcTest``.
  ///
  /// If executed outside of a test process, this will return `nil`.
  public static var current: Self? {
    guard isTesting else { return nil }
    if let currentTestID = _currentTestID() {
      return .swiftTesting(Testing(id: currentTestID))
    } else {
      return .xcTest
    }
  }

  /// Determines if the test context is Swift's native Testing framework.
  public var isSwiftTesting: Bool {
    guard case .swiftTesting = self
    else { return false }
    return true
  }

  public struct Testing: Equatable, Sendable {
    public let test: Test

    public struct Test: Equatable, Hashable, Identifiable, Sendable {
      public let id: ID

      public struct ID: Equatable, Hashable, @unchecked Sendable {
        public let rawValue: AnyHashable
      }
    }
  }

  @available(*, deprecated, message: "Test using pattern matching, instead.")
  public static func == (lhs: Self, rhs: Self) -> Bool {
    switch (lhs, rhs) {
    case (.swiftTesting(nil), .swiftTesting),
      (.swiftTesting, .swiftTesting(nil)),
      (.xcTest, .xcTest):
      return true
    case (.swiftTesting(let lhs), .swiftTesting(let rhs)):
      return lhs == rhs
    case (.swiftTesting, .xcTest), (.xcTest, .swiftTesting):
      return false
    }
  }

  @available(
    *, deprecated,
    message: "Test for '.swiftTesting' using pattern matching or 'isSwiftTesting', instead."
  )
  public static var swiftTesting: Self {
    .swiftTesting(nil)
  }
}

extension TestContext.Testing {
  fileprivate init(id: AnyHashable) {
    self.init(test: Test(id: Test.ID(rawValue: id)))
  }
}

extension TestContext {
  /// Indicates whether or not test failures should be emitted by default when an issue is reported.
  public static var emitsFailureOnReportIssue: Bool {
    get { _emitsFailureOnReportIssue.withLock { $0 } }
    set { _emitsFailureOnReportIssue.withLock { $0 = newValue } }
  }

  @TaskLocal fileprivate static var _emitsFailureOnReportIssue = LockIsolated<Bool>(true)
}

public func withEmitsFailureOnReportIssue<R>(
  _ value: Bool,
  operation: () throws -> R
) rethrows -> R {
  try TestContext.$_emitsFailureOnReportIssue.withValue(LockIsolated(value), operation: operation)
}

#if compiler(>=6)
  /// Overrides the task's issue reporters for the duration of the asynchronous operation.
  ///
  /// An asynchronous version of ``withIssueReporters(_:operation:)-91179``.
  ///
  /// - Parameters:
  ///   - reporters: Issue reporters to notify during the operation.
  ///   - isolation: The isolation associated with the operation.
  ///   - operation: An asynchronous operation.
  public func withEmitsFailureOnReportIssue<R>(
    _ value: Bool,
    isolation: isolated (any Actor)? = #isolation,
    operation: () async throws -> R
  ) async rethrows -> R {
    try await TestContext.$_emitsFailureOnReportIssue.withValue(LockIsolated(value), operation: operation)
  }
#else
  @_unsafeInheritExecutor
  public func withIssueReporters<R>(
    _ value: Bool,
    operation: () async throws -> R
  ) async rethrows -> R {
    try await TestContext.$_emitsFailureOnReportIssue.withValue(LockIsolated(value), operation: operation)
  }
#endif
