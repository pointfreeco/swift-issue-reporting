// MARK: (Parameters) -> Result

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable () -> Result {
  return {
    _fail(description(), nil)
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable () -> Result {
  return {
    let description = description()
    _fail(description, nil)
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A) -> Result {
  return {
    _fail(description(), $0)
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A) -> Result {
  return {
    let description = description()
    _fail(description, $0)
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B) -> Result {
  return {
    _fail(description(), ($0, $1))
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B) -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1))
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C) -> Result {
  return {
    _fail(description(), ($0, $1, $2))
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C) -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2))
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D) -> Result {
  return {
    _fail(description(), ($0, $1, $2, $3))
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D) -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3))
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D, E) -> Result {
  return {
    _fail(description(), ($0, $1, $2, $3, $4))
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3, $4))
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

// MARK: (Parameters) throws -> Result

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable () throws -> Result {
  return {
    let description = description()
    _fail(description, nil)
    throw XCTUnimplementedFailure(description: description)
  }
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A) throws -> Result {
  return {
    let description = description()
    _fail(description, $0)
    throw XCTUnimplementedFailure(description: description)
  }
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1))
    throw XCTUnimplementedFailure(description: description)
  }
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2))
    throw XCTUnimplementedFailure(description: description)
  }
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3))
    throw XCTUnimplementedFailure(description: description)
  }
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D, E) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3, $4))
    throw XCTUnimplementedFailure(description: description)
  }
}

// MARK: (Parameters) async -> Result

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable () async -> Result {
  return {
    _fail(description(), nil)
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable () async -> Result {
  return {
    let description = description()
    _fail(description, nil)
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
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
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A) async -> Result {
  return {
    _fail(description(), $0)
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A) async -> Result {
  return {
    let description = description()
    _fail(description, $0)
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B) async -> Result {
  return {
    _fail(description(), ($0, $1))
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B) async -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1))
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C) async -> Result {
  return {
    _fail(description(), ($0, $1, $2))
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C) async -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2))
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D) async -> Result {
  return {
    _fail(description(), ($0, $1, $2, $3))
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D) async -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3))
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D, E) async -> Result {
  return {
    _fail(description(), ($0, $1, $2, $3, $4))
    return placeholder()
  }
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) async -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3, $4))
    guard let placeholder: Result = _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

// MARK: (Parameters) async throws -> Result

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable () async throws -> Result {
  return {
    let description = description()
    _fail(description, nil)
    throw XCTUnimplementedFailure(description: description)
  }
}

/// Returns a closure that generates a failure when invoked.
///
/// - Parameter description: An optional description of the unimplemented closure, for inclusion in
///   test results.
/// - Returns: A closure that generates a failure and throws an error when invoked.
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A) async throws -> Result {
  return {
    let description = description()
    _fail(description, $0)
    throw XCTUnimplementedFailure(description: description)
  }
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1))
    throw XCTUnimplementedFailure(description: description)
  }
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2))
    throw XCTUnimplementedFailure(description: description)
  }
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3))
    throw XCTUnimplementedFailure(description: description)
  }
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D, E) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3, $4))
    throw XCTUnimplementedFailure(description: description)
  }
}

/// An error thrown from ``XCTUnimplemented(_:)-3obl5``.
@available(*, deprecated, renamed: "UnimplementedFailure")
public struct XCTUnimplementedFailure: Error {
  public let description: String
}
