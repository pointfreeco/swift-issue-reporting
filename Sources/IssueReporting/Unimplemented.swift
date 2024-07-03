@Sendable
public func unimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result = (),
  fileID: StaticString = #fileID,
  line: UInt = #line,
  function: StaticString = #function
) -> @Sendable (repeat each A) -> Result {
  return { (arg: repeat each A) in
    _fail(description(), (repeat each arg), fileID: fileID, line: line, function: function)
    return placeholder()
  }
}

@Sendable
public func unimplemented<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result = (),
  fileID: StaticString = #fileID,
  line: UInt = #line,
  function: StaticString = #function
) -> @Sendable (repeat each A) async -> Result {
  return { (arg: repeat each A) in
    _fail(description(), (repeat each arg), fileID: fileID, line: line, function: function)
    return placeholder()
  }
}

@Sendable
public func throwing<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line,
  function: StaticString = #function
) -> @Sendable (repeat each A) throws -> Result {
  return { (arg: repeat each A) in
    let description = description()
    _fail(description, (repeat each arg), fileID: fileID, line: line, function: function)
    throw UnimplementedFailure(description: description)
  }
}

@Sendable
public func throwing<each A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line,
  function: StaticString = #function
) -> @Sendable (repeat each A) async throws -> Result {
  return { (arg: repeat each A) in
    let description = description()
    _fail(description, (repeat each arg), fileID: fileID, line: line, function: function)
    throw UnimplementedFailure(description: description)
  }
}

private struct UnimplementedFailure: Error {
  public let description: String
}

private func _fail(
  _ description: String,
  _ parameters: Any?,
  fileID: StaticString,
  line: UInt,
  function: StaticString
) {
  var debugDescription = """
     …

      Defined in '\(function)' at:
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
  reportIssue(
    """
    Unimplemented\(description.isEmpty ? "" : ": \(description)")\(debugDescription)
    """
  )
}
