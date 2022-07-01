// MARK: (Parameters) -> Result

@_disfavoredOverload
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable () -> Result {
  return {
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A) -> Result {
  return { _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B) -> Result {
  return { _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C) -> Result {
  return { _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D) -> Result {
  return { _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) -> Result {
  return { _, _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

// MARK: (Parameters) throws -> Result

public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable () throws -> Result {
  return {
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A) throws -> Result {
  return { _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B) throws -> Result {
  return { _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C) throws -> Result {
  return { _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D) throws -> Result {
  return { _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D, E) throws -> Result {
  return { _, _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

// MARK: (Parameters) async -> Result

@_disfavoredOverload
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable () async -> Result {
  return {
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
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
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A) async -> Result {
  return { _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B) async -> Result {
  return { _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C) async -> Result {
  return { _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D) async -> Result {
  return { _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) async -> Result {
  return { _, _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    guard let placeholder = placeholder() ?? _generatePlaceholder()
    else { _unimplementedFatalError(description, file: file, line: line) }
    return placeholder
  }
}

// MARK: (Parameters) async throws -> Result

public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable () async throws -> Result {
  return {
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

/// Returns a closure that generates a failure when invoked.
///
/// - Parameter description: An optional description of the unimplemented closure, for inclusion in
///   test results.
/// - Returns: A closure that generates a failure and throws an error when invoked.
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A) async throws -> Result {
  return { _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B) async throws -> Result {
  return { _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C) async throws -> Result {
  return { _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D) async throws -> Result {
  return { _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D, E) async throws -> Result {
  return { _, _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

/// An error thrown from ``XCTUnimplemented(_:)-3obl5``.
public struct XCTUnimplementedFailure: Error {
  public let description: String
}

private func _generatePlaceholder<Result>() -> Result? {
  if Result.self == Void.self {
    return () as? Result
  }
  if let result = (Witness<Result>.self as? AnyRangeReplaceableCollection.Type)?.empty() as? Result
  {
    return result
  }
  return nil
}

private func _unimplementedFatalError(_ message: String, file: StaticString, line: UInt) -> Never {
  fatalError(
    """
    XCTUnimplemented(\(message.isEmpty ? "" : message.debugDescription))

    To suppress this crash, provide an explicit "placeholder".
    """,
    file: file,
    line: line
  )
}

protocol AnyRangeReplaceableCollection {
  static func empty() -> Any
}
private enum Witness<Value> {}
extension Witness: AnyRangeReplaceableCollection where Value: RangeReplaceableCollection {
  static func empty() -> Any {
    Value()
  }
}
