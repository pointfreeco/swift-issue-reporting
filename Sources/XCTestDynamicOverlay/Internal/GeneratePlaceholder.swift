func _generatePlaceholder<Result>() -> Result? {
  if Result.self == Void.self {
    return () as? Result
  }
  if let result = (Witness<Result>.self as? AnyRangeReplaceableCollection.Type)?.empty() as? Result {
    return result
  }
  return nil
}

protocol AnyRangeReplaceableCollection {
  static func empty() -> Any
}

enum Witness<Value> {}
extension Witness: AnyRangeReplaceableCollection where Value: RangeReplaceableCollection {
  static func empty() -> Any {
    Value()
  }
}
