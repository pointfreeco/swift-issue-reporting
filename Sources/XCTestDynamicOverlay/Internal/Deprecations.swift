// MARK: (Parameters) -> Result

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (repeat each A) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (repeat each A) -> Result {
  unimplemented(description(), file: file, line: line)
}

// MARK: (Parameters) throws -> Result

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (repeat each A) throws -> Result {
  unimplemented(description())
}

// MARK: (Parameters) async -> Result

/// Returns a closure that generates a failure when invoked.
///
/// - Parameters:
///   - description: An optional description of the unimplemented closure, for inclusion in test
///     results.
///   - placeholder: An optional placeholder value returned from the closure. If omitted and a
///     default value (like `()` for `Void`) cannot be returned, calling the closure will fatal
///     error instead.
/// - Returns: A closure that generates a failure when invoked.
@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (repeat each A) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (repeat each A) async -> Result {
  unimplemented(description(), file: file, line: line)
}

// MARK: (Parameters) async throws -> Result

/// Returns a closure that generates a failure when invoked.
///
/// - Parameter description: An optional description of the unimplemented closure, for inclusion in
///   test results.
/// - Returns: A closure that generates a failure and throws an error when invoked.
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (repeat each A) async throws -> Result {
  unimplemented(description())
}

/// An error thrown from ``XCTUnimplemented(_:)-3obl5``.
@available(iOS, deprecated: 9999, renamed: "UnimplementedFailure")
@available(macOS, deprecated: 9999, renamed: "UnimplementedFailure")
@available(tvOS, deprecated: 9999, renamed: "UnimplementedFailure")
@available(watchOS, deprecated: 9999, renamed: "UnimplementedFailure")
public typealias XCTUnimplementedFailure = UnimplementedFailure
