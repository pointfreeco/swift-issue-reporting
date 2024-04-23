// MARK: (Parameters) -> Result

@_disfavoredOverload
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> Result {
  _fail(description(), nil, fileID: fileID, line: line)
  return placeholder()
}

@_disfavoredOverload
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

public func unimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (repeat each A) -> Result {
  return { (arg: repeat each A) in
    _fail(description(), (repeat each arg), fileID: fileID, line: line)
    return placeholder()
  }
}

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

// MARK: (Parameters) throws -> Result

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
public func unimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (repeat each A) async -> Result {
  return { (arg: repeat each A) in
    _fail(description(), (repeat (each arg)), fileID: fileID, line: line)
    return placeholder()
  }
}

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

// MARK: (Parameters) async throws -> Result

/// Returns a closure that generates a failure when invoked.
///
/// - Parameter description: An optional description of the unimplemented closure, for inclusion in
///   test results.
/// - Returns: A closure that generates a failure and throws an error when invoked.
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

/// An error thrown from ``XCTUnimplemented(_:)-3obl5``.
public struct UnimplementedFailure: Error {
  public let description: String
}

func _fail(_ description: String, _ parameters: Any?, fileID: StaticString, line: UInt) {
  var debugDescription = """
     …

      Defined at:
        \(fileID):\(line)
    """
  if let parameters = parameters {
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

func _unimplementedFatalError(_ message: String, file: StaticString, line: UInt) -> Never {
  fatalError(
    """
    unimplemented(\(message.isEmpty ? "" : message.debugDescription))

    To suppress this crash, provide an explicit "placeholder".
    """,
    file: file,
    line: line
  )
}
