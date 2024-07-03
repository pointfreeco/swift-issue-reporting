/// Returns a closure that reports an issue when invoked.
///
/// - Parameters:
///   - description: An optional description of the unimplemented closure.
///   - placeholder: A placeholder value returned from the closure when left unimplemented.
/// - Returns: A closure that reports an issue when invoked.
public func unimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result = (),
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (repeat each A) -> Result {
  return { (arg: repeat each A) in
    _fail(description(), (repeat each arg), fileID: fileID, line: line)
    return placeholder()
  }
}

/// Returns a throwing closure that reports an issue and throws an error when invoked.
///
/// - Parameter description: An optional description of the unimplemented closure.
/// - Returns: A throwing closure that reports an issue and throws an error when invoked.
public func unimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (repeat each A) throws -> Result {
  return { (arg: repeat each A) in
    let description = description()
    _fail(description, (repeat (each arg)), fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

/// Returns an asynchronous closure that reports an issue when invoked.
///
/// - Parameters:
///   - description: An optional description of the unimplemented closure.
///   - placeholder: A placeholder value returned from the closure when left unimplemented.
/// - Returns: An asynchronous closure that reports an issue when invoked.
public func unimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result = (),
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (repeat each A) async -> Result {
  return { (arg: repeat each A) in
    _fail(description(), (repeat (each arg)), fileID: fileID, line: line)
    return placeholder()
  }
}

/// Returns a throwing, asynchronous closure that reports an issue and throws an error when invoked.
///
/// - Parameter description: An optional description of the unimplemented closure.
/// - Returns: A throwing, asynchronous closure that reports an issue and throws an error when
///   invoked.
public func unimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (repeat each A) async throws -> Result {
  return { (arg: repeat each A) in
    let description = description()
    _fail(description, (repeat (each arg)), fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@_disfavoredOverload
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result = (),
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> Result {
  _fail(description(), nil, fileID: fileID, line: line)
  return placeholder()
}

/// An error thrown from throwing `unimplemented` closures.
public struct UnimplementedFailure: Error {
  public let description: String
}

func _fail(_ description: String, _ parameters: Any?, fileID: StaticString, line: UInt) {
  var debugDescription = """
     …

      Defined at:
        \(fileID):\(line)
    """
  if let parameters {
    var parametersDescription = ""
    debugPrint(parameters, terminator: "", to: &parametersDescription)
    debugDescription.append(
      """


        Invoked with:
          \(parametersDescription)
      """
    )
  }
  XCTFail(
    """
    Unimplemented\(description.isEmpty ? "" : ": \(description)")\(debugDescription)
    """
  )
}
