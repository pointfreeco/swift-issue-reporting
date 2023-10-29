// MARK: (Parameters) -> Result

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable () -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable () -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A) -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B) -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C) -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D) -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D, E) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) -> Result {
  unimplemented(description(), file: file, line: line)
}

// MARK: (Parameters) throws -> Result

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable () throws -> Result {
  unimplemented(description())
}

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A) throws -> Result {
  unimplemented(description())
}

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B) throws -> Result {
  unimplemented(description())
}

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C) throws -> Result {
  unimplemented(description())
}

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D) throws -> Result {
  unimplemented(description())
}

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D, E) throws -> Result {
  unimplemented(description())
}

// MARK: (Parameters) async -> Result

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable () async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable () async -> Result {
  unimplemented(description(), file: file, line: line)
}

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
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A) async -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B) async -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C) async -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D) async -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D, E) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) async -> Result {
  unimplemented(description(), file: file, line: line)
}

// MARK: (Parameters) async throws -> Result

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable () async throws -> Result {
  unimplemented(description())
}

/// Returns a closure that generates a failure when invoked.
///
/// - Parameter description: An optional description of the unimplemented closure, for inclusion in
///   test results.
/// - Returns: A closure that generates a failure and throws an error when invoked.
@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A) async throws -> Result {
  unimplemented(description())
}

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B) async throws -> Result {
  unimplemented(description())
}

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C) async throws -> Result {
  unimplemented(description())
}

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D) async throws -> Result {
  unimplemented(description())
}

@available(iOS, deprecated: 9999, renamed: "unimplemented")
@available(macOS, deprecated: 9999, renamed: "unimplemented")
@available(tvOS, deprecated: 9999, renamed: "unimplemented")
@available(watchOS, deprecated: 9999, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D, E) async throws -> Result {
  unimplemented(description())
}

/// An error thrown from ``XCTUnimplemented(_:)-3obl5``.
@available(iOS, deprecated: 9999, renamed: "UnimplementedFailure")
@available(macOS, deprecated: 9999, renamed: "UnimplementedFailure")
@available(tvOS, deprecated: 9999, renamed: "UnimplementedFailure")
@available(watchOS, deprecated: 9999, renamed: "UnimplementedFailure")
public typealias XCTUnimplementedFailure = Unimplemented
