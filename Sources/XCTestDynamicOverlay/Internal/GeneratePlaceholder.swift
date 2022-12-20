extension _DefaultInitializable { fileprivate static var placeholder: Self { Self() } }
extension AdditiveArithmetic { fileprivate static var placeholder: Self { .zero } }
extension ExpressibleByArrayLiteral { fileprivate static var placeholder: Self { [] } }
extension ExpressibleByBooleanLiteral { fileprivate static var placeholder: Self { false } }
extension ExpressibleByDictionaryLiteral { fileprivate static var placeholder: Self { [:] } }
extension ExpressibleByFloatLiteral { fileprivate static var placeholder: Self { 0.0 } }
extension ExpressibleByIntegerLiteral { fileprivate static var placeholder: Self { 0 } }
extension ExpressibleByUnicodeScalarLiteral { fileprivate static var placeholder: Self { " " } }
extension RangeReplaceableCollection { fileprivate static var placeholder: Self { Self() } }

#if swift(>=5.7)

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

private func _rawRepresentable<Result>() -> Result? {
  func posiblePlaceholder<T: RawRepresentable>(for type: T.Type) -> T? {
    (_placeholder() as T.RawValue?).flatMap(T.init(rawValue:))
  }

  return (Result.self as? any RawRepresentable.Type).flatMap {
    posiblePlaceholder(for: $0) as? Result
  }
}

private func _caseIterable<Result>() -> Result? {
  func firstCase<T: CaseIterable>(for type: T.Type) -> Result? {
    T.allCases.first as? Result
  }

  return (Result.self as? any CaseIterable.Type).flatMap {
    firstCase(for: $0)
  }
}

#else

private func _placeholder<Result>() -> Result? {
  if let result = (Result.self as? _DefaultInitializable.Type)?.placeholder {
    return result as? Result
  }

  if Result.self == Void.self {
    return () as? Result
  }

  switch Witness<Result>.self {
  case let type as AnyRangeReplaceableCollection.Type: return type.placeholder as? Result
  case let type as AnyAdditiveArithmetic.Type: return type.placeholder as? Result
  case let type as AnyExpressibleByArrayLiteral.Type: return type.placeholder as? Result
  case let type as AnyExpressibleByBooleanLiteral.Type: return type.placeholder as? Result
  case let type as AnyExpressibleByDictionaryLiteral.Type: return type.placeholder as? Result
  case let type as AnyExpressibleByFloatLiteral.Type: return type.placeholder as? Result
  case let type as AnyExpressibleByIntegerLiteral.Type: return type.placeholder as? Result
  case let type as AnyExpressibleByUnicodeScalarLiteral.Type: return type.placeholder as? Result
  default: return nil
  }
}

private func _rawRepresentable<Result>() -> Result? {
  (Witness<Result>.self as? AnyRawRepresentable.Type).flatMap {
    $0.possiblePlaceholder as? Result
  }
}

private func _caseIterable<Result>() -> Result? {
  (Witness<Result>.self as? AnyCaseIterable.Type).flatMap {
    $0.firstCase as? Result
  }
}

private enum Witness<Value> {}
private protocol AnyAdditiveArithmetic { static var placeholder: Any { get } }
extension Witness: AnyAdditiveArithmetic where Value: AdditiveArithmetic {
  fileprivate static var placeholder: Any { Value.placeholder }
}

private protocol AnyExpressibleByArrayLiteral { static var placeholder: Any { get } }
extension Witness: AnyExpressibleByArrayLiteral where Value: ExpressibleByArrayLiteral {
  fileprivate static var placeholder: Any { Value.placeholder }
}

private protocol AnyExpressibleByBooleanLiteral { static var placeholder: Any { get } }
extension Witness: AnyExpressibleByBooleanLiteral where Value: ExpressibleByBooleanLiteral {
  fileprivate static var placeholder: Any { Value.placeholder }
}

private protocol AnyExpressibleByDictionaryLiteral { static var placeholder: Any { get } }
extension Witness: AnyExpressibleByDictionaryLiteral where Value: ExpressibleByDictionaryLiteral {
  fileprivate static var placeholder: Any { Value.placeholder }
}

private protocol AnyExpressibleByFloatLiteral { static var placeholder: Any { get } }
extension Witness: AnyExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {
  fileprivate static var placeholder: Any { Value.placeholder }
}

private protocol AnyExpressibleByIntegerLiteral { static var placeholder: Any { get } }
extension Witness: AnyExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {
  fileprivate static var placeholder: Any { Value.placeholder }
}

private protocol AnyExpressibleByUnicodeScalarLiteral { static var placeholder: Any { get } }
extension Witness: AnyExpressibleByUnicodeScalarLiteral
where Value: ExpressibleByUnicodeScalarLiteral {
  fileprivate static var placeholder: Any { Value.placeholder }
}

private protocol AnyRangeReplaceableCollection { static var placeholder: Any { get } }
extension Witness: AnyRangeReplaceableCollection where Value: RangeReplaceableCollection {
  fileprivate static var placeholder: Any { Value.placeholder }
}

private protocol AnyRawRepresentable { static var possiblePlaceholder: Any? { get } }
extension Witness: AnyRawRepresentable where Value: RawRepresentable {
  fileprivate static var possiblePlaceholder: Any? {
    (_placeholder() as Value.RawValue?).flatMap(Value.init(rawValue:))
  }
}

private protocol AnyCaseIterable { static var firstCase: Any? { get } }
extension Witness: AnyCaseIterable where Value: CaseIterable {
  fileprivate static var firstCase: Any? {
    Value.allCases.first
  }
}

#endif

func _generatePlaceholder<Result>() -> Result? {
  if let result = _placeholder() as Result? {
    return result
  }

  if let result = _rawRepresentable() as Result? {
    return result
  }

  if let result = _caseIterable() as Result? {
    return result
  }

  return nil
}
