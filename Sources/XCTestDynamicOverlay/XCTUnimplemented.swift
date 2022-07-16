#if canImport(Foundation)
import Foundation
#endif
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
    _fail(description, nil)
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
  return {
    let description = description()
    _fail(description, $0)
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
  return {
    let description = description()
    _fail(description, ($0, $1))
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
  return {
    let description = description()
    _fail(description, ($0, $1, $2))
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
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3))
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
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3, $4))
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
    _fail(description, nil)
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A) throws -> Result {
  return {
    let description = description()
    _fail(description, $0)
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1))
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2))
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3))
    throw XCTUnimplementedFailure(description: description)
  }
}

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
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result? = nil,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable () async -> Result {
  return {
    let description = description()
    _fail(description, nil)
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
  return {
    let description = description()
    _fail(description, $0)
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
  return {
    let description = description()
    _fail(description, ($0, $1))
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
  return {
    let description = description()
    _fail(description, ($0, $1, $2))
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
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3))
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
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3, $4))
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
    _fail(description, nil)
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
  return {
    let description = description()
    _fail(description, $0)
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1))
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2))
    throw XCTUnimplementedFailure(description: description)
  }
}

public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3))
    throw XCTUnimplementedFailure(description: description)
  }
}

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
public struct XCTUnimplementedFailure: Error {
  public let description: String
}

private func _fail(_ description: String, _ parameters: Any?) {
  let parametersDescription =
    parameters.map {
      """
       …

      Invoked with:

        \($0)
      """
    }
    ?? ""
  XCTFail(
    """
    Unimplemented\(description.isEmpty ? "" : ": \(description)")\(parametersDescription)
    """
  )
}

private func _generatePlaceholder<Result>() -> Result? {
  if Result.self == Void.self {
    return () as? Result
  }
  if let result = (Witness<Result>.self as? AnyRangeReplaceableCollection.Type)?.empty() as? Result
  {
    return result
  }
  if let result = (Witness<Result>.self as? AnyExpressibleByArrayLiteral.Type)?.empty() as? Result {
    return result
  }
  if let result = (Witness<Result>.self as? AnyFixedWidthInteger.Type)?.zero() as? Result {
    return result
  }
  if let result = (Witness<Result>.self as? AnyBinaryFloatingPoint.Type)?.zero() as? Result {
    return result
  }
  if let result = (Result.self as? DefaultConstructible.Type)?.init() as? Result {
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

private enum Witness<Value> {}
protocol AnyRangeReplaceableCollection {
  static func empty() -> Any
}

extension Witness: AnyRangeReplaceableCollection where Value: RangeReplaceableCollection {
  static func empty() -> Any {
    Value()
  }
}

protocol AnyExpressibleByArrayLiteral {
  static func empty() -> Any
}

extension Witness: AnyExpressibleByArrayLiteral where Value: ExpressibleByArrayLiteral {
  static func empty() -> Any {
    [] as Value
  }
}

protocol AnyExpressibleByDictionaryLiteral {
  static func empty() -> Any
}

extension Witness: AnyExpressibleByDictionaryLiteral where Value: ExpressibleByDictionaryLiteral {
  static func empty() -> Any {
    [:] as Value
  }
}

protocol AnyFixedWidthInteger {
  static func zero() -> Any
}

extension Witness: AnyFixedWidthInteger where Value: FixedWidthInteger {
  static func zero() -> Any {
    Value.zero
  }
}

protocol AnyBinaryFloatingPoint {
  static func zero() -> Any
}

extension Witness: AnyBinaryFloatingPoint where Value: BinaryFloatingPoint {
  static func zero() -> Any {
    Value.zero
  }
}

protocol DefaultConstructible {
  init()
}

extension Bool: DefaultConstructible {}
extension Set: DefaultConstructible {}
extension Dictionary: DefaultConstructible {}
#if canImport(Foundation)
extension Date: DefaultConstructible {}
extension UUID: DefaultConstructible {}
extension URL: DefaultConstructible {
  init() { self.init(string: "/")! }
}
#endif
