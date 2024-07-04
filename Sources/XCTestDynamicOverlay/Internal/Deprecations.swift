// NB: Deprecated after 1.1.2

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented(_:placeholder:)")
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> Result {
  let description = description()
  _fail(description, nil, fileID: fileID, line: line)
  do {
    return try _generatePlaceholder()
  } catch {
    _unimplementedFatalError(description, file: file, line: line)
  }
}

@available(*, deprecated, renamed: "unimplemented(_:placeholder:)")
public func unimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (repeat each A) -> Result {
  return { (arg: repeat each A) in
    let description = description()
    _fail(description, (repeat (each arg)), fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(*, deprecated, renamed: "unimplemented(_:placeholder:)")
public func unimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (repeat each A) async -> Result {
  return { (arg: repeat each A) in
    let description = description()
    _fail(description, (repeat (each arg)), fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(*, deprecated)
private func _unimplementedFatalError(_ message: String, file: StaticString, line: UInt) -> Never {
  fatalError(
    """
    unimplemented(\(message.isEmpty ? "" : message.debugDescription))

    To suppress this crash, provide an explicit "placeholder".
    """,
    file: file,
    line: line
  )
}

@available(*, deprecated)
extension _DefaultInitializable { fileprivate static var placeholder: Self { Self() } }
extension AdditiveArithmetic { fileprivate static var placeholder: Self { .zero } }
extension ExpressibleByArrayLiteral { fileprivate static var placeholder: Self { [] } }
extension ExpressibleByBooleanLiteral { fileprivate static var placeholder: Self { false } }
extension ExpressibleByDictionaryLiteral { fileprivate static var placeholder: Self { [:] } }
extension ExpressibleByFloatLiteral { fileprivate static var placeholder: Self { 0.0 } }
extension ExpressibleByIntegerLiteral { fileprivate static var placeholder: Self { 0 } }
extension ExpressibleByUnicodeScalarLiteral { fileprivate static var placeholder: Self { " " } }
extension RangeReplaceableCollection { fileprivate static var placeholder: Self { Self() } }

@available(*, deprecated)
private protocol _OptionalProtocol { static var none: Self { get } }
@available(*, deprecated)
extension Optional: _OptionalProtocol {}
@available(*, deprecated)
private func _optionalPlaceholder<Result>() throws -> Result {
  if let result = (Result.self as? _OptionalProtocol.Type) {
    return result.none as! Result
  }
  throw PlaceholderGenerationFailure()
}

@available(*, deprecated)
private func _placeholder<Result>() -> Result? {
  switch Result.self {
  case let type as _DefaultInitializable.Type: return type.placeholder as? Result
  case is Void.Type: return () as? Result
  case let type as any RangeReplaceableCollection.Type: return type.placeholder as? Result
  case let type as any AdditiveArithmetic.Type: return type.placeholder as? Result
  case let type as any ExpressibleByArrayLiteral.Type: return type.placeholder as? Result
  case let type as any ExpressibleByBooleanLiteral.Type: return type.placeholder as? Result
  case let type as any ExpressibleByDictionaryLiteral.Type: return type.placeholder as? Result
  case let type as any ExpressibleByFloatLiteral.Type: return type.placeholder as? Result
  case let type as any ExpressibleByIntegerLiteral.Type: return type.placeholder as? Result
  case let type as any ExpressibleByUnicodeScalarLiteral.Type: return type.placeholder as? Result
  default: return nil
  }
}

@available(*, deprecated)
private func _rawRepresentable<Result>() -> Result? {
  func posiblePlaceholder<T: RawRepresentable>(for type: T.Type) -> T? {
    (_placeholder() as T.RawValue?).flatMap(T.init(rawValue:))
  }

  return (Result.self as? any RawRepresentable.Type).flatMap {
    posiblePlaceholder(for: $0) as? Result
  }
}

@available(*, deprecated)
private func _caseIterable<Result>() -> Result? {
  func firstCase<T: CaseIterable>(for type: T.Type) -> Result? {
    T.allCases.first as? Result
  }

  return (Result.self as? any CaseIterable.Type).flatMap {
    firstCase(for: $0)
  }
}

@available(*, deprecated)
struct PlaceholderGenerationFailure: Error {}
@available(*, deprecated)
func _generatePlaceholder<Result>() throws -> Result {
  if let result = _placeholder() as Result? {
    return result
  }

  if let result = _rawRepresentable() as Result? {
    return result
  }

  if let result = _caseIterable() as Result? {
    return result
  }

  return try _optionalPlaceholder()
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (repeat each A) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (repeat each A) -> Result {
  unimplemented(description(), file: file, line: line)
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (repeat each A) throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (repeat each A) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (repeat each A) async -> Result {
  unimplemented(description(), file: file, line: line)
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (repeat each A) async throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "UnimplementedFailure")
public typealias XCTUnimplementedFailure = UnimplementedFailure
