// MARK: (Parameters) -> Void

/// Returns a closure that generates a failure when invoked.
///
/// - Parameter description: An optional description of the unimplemented closure, for inclusion in
///   test results.
/// - Returns: A closure that generates a failure when invoked.
@_disfavoredOverload
public func XCTUnimplemented(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable () -> Void {
  return {
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A) -> Void {
  return { _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B) -> Void {
  return { _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C) -> Void {
  return { _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C, D) -> Void {
  return { _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, E>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C, D, E) -> Void {
  return { _, _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

// MARK: (Parameters) -> Result

/// Returns a closure that generates a failure when invoked.
///
/// - Parameters:
///   - description: An optional description of the unimplemented closure, for inclusion in test
///     results.
///   - placeholder: A placeholder value returned from the closure.
/// - Returns: A closure that generates a failure when invoked.
@_disfavoredOverload
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable () -> Result {
  return {
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable (A) -> Result {
  return { _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable (A, B) -> Result {
  return { _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable (A, B, C) -> Result {
  return { _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable (A, B, C, D) -> Result {
  return { _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable (A, B, C, D, E) -> Result {
  return { _, _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

// MARK: (Parameters) throws -> Result

@_disfavoredOverload
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable () throws -> Result {
  return {
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A) throws -> Result {
  return { _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B) throws -> Result {
  return { _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C) throws -> Result {
  return { _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C, D) throws -> Result {
  return { _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C, D, E) throws -> Result {
  return { _, _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

// MARK: (Parameters) async -> Void

@_disfavoredOverload
public func XCTUnimplemented(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable () async -> Void {
  return {
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A) async -> Void {
  return { _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B) async -> Void {
  return { _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C) async -> Void {
  return { _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C, D) async -> Void {
  return { _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, E>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C, D, E) async -> Void {
  return { _, _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
  }
}

// MARK: (Parameters) async -> Result

@_disfavoredOverload
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable () async -> Result {
  return {
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable (A) async -> Result {
  return { _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable (A, B) async -> Result {
  return { _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable (A, B, C) async -> Result {
  return { _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable (A, B, C, D) async -> Result {
  return { _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping () -> String = "",
  placeholder: @autoclosure @escaping () -> Result
) -> @Sendable (A, B, C, D, E) async -> Result {
  return { _, _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    return placeholder()
  }
}

// MARK: (Parameters) async throws -> Result

@_disfavoredOverload
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable () async throws -> Result {
  return {
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A) async throws -> Result {
  return { _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B) async throws -> Result {
  return { _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C) async throws -> Result {
  return { _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C, D) async throws -> Result {
  return { _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping () -> String = ""
) -> @Sendable (A, B, C, D, E) async throws -> Result {
  return { _, _, _, _, _ in
    let description = description()
    XCTFail("Unimplemented\(description.isEmpty ? "" : ": \(description)")")
    throw XCTUnimplementedFailure(description: description)
  }
}

public struct XCTUnimplementedFailure: Error {
  public let description: String
}
