// MARK: (Parameters) -> Result

public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () -> Result {
  return {
    _fail(description(), [], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () -> Result {
  return {
    let description = description()
    _fail(description, [], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@_disfavoredOverload
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> Result {
  _fail(description(), [], fileID: fileID, line: line)
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
  _fail(description, [], fileID: fileID, line: line)
  do {
    return try _generatePlaceholder()
  } catch {
    _unimplementedFatalError(description, file: file, line: line)
  }
}

public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) -> Result {
  return {
    _fail(description(), [$0], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) -> Result {
  return {
    let description = description()
    _fail(description, [$0], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) -> Result {
  return {
    _fail(description(), [$0, $1], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) -> Result {
  return {
    _fail(description(), [$0, $1, $2], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) -> Result {
  return {
    _fail(description(), [$0, $1, $2, $3], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2, $3], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) -> Result {
  return {
    _fail(description(), [$0, $1, $2, $3, $4], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2, $3, $4], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

// MARK: (Parameters) throws -> Result

public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () throws -> Result {
  return {
    let description = description()
    _fail(description, [], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) throws -> Result {
  return {
    let description = description()
    _fail(description, [$0], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) throws -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) throws -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) throws -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2, $3], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) throws -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2, $3, $4], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

// MARK: (Parameters) async -> Result

public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () async -> Result {
  return {
    _fail(description(), [], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () async -> Result {
  return {
    let description = description()
    _fail(description, [], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
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
public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) async -> Result {
  return {
    _fail(description(), [$0], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) async -> Result {
  return {
    let description = description()
    _fail(description, [$0], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) async -> Result {
  return {
    _fail(description(), [$0, $1], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) async -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) async -> Result {
  return {
    _fail(description(), [$0, $1, $2], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) async -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) async -> Result {
  return {
    _fail(description(), [$0, $1, $2, $3], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) async -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2, $3], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) async -> Result {
  return {
    _fail(description(), [$0, $1, $2, $3, $4], fileID: fileID, line: line)
    return placeholder()
  }
}

public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) async -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2, $3, $4], fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

// MARK: (Parameters) async throws -> Result

public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () async throws -> Result {
  return {
    let description = description()
    _fail(description, [], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

/// Returns a closure that generates a failure when invoked.
///
/// - Parameter description: An optional description of the unimplemented closure, for inclusion in
///   test results.
/// - Returns: A closure that generates a failure and throws an error when invoked.
public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) async throws -> Result {
  return {
    let description = description()
    _fail(description, [$0], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) async throws -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) async throws -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) async throws -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2, $3], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) async throws -> Result {
  return {
    let description = description()
    _fail(description, [$0, $1, $2, $3, $4], fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

/// An error thrown from ``XCTUnimplemented(_:)-3obl5``.
public struct UnimplementedFailure: Error {
  public let description: String
}

func _fail(_ description: String, _ parameters: [Any], fileID: StaticString, line: UInt) {
  var debugDescription = """
     …

      Defined at:
        \(fileID):\(line)
    """
  if !parameters.isEmpty {
    let parameterDescriptions = parameters.map { parameter in
      var description = ""
      debugPrint(parameter, terminator: "", to: &description)
      return description
    }

    let tooLongForOneLine = parameterDescriptions.reduce(0, { $0 + $1.count }) > 70
    let containsNewLine = parameterDescriptions.contains(where: { $0.contains("\n") })
    let parametersDescription = if parameterDescriptions.count == 1 {
      parameterDescriptions[0]
    } else if tooLongForOneLine || containsNewLine {
      [
        "(\n",
        parameterDescriptions.joined(separator: ",\n").prefixingEachLine(with: "  "),
        "\n)"
      ]
      .joined()
    } else {
      "(" + parameterDescriptions.joined(separator: ", ") + ")"
    }
    debugDescription.append(
      """


        Invoked with:
      \(parametersDescription.prefixingEachLine(with: "    "))
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

private extension String {
  func prefixingEachLine(with prefix: String) -> String {
    prefix + replacingOccurrences(of: "\n", with: "\n\(prefix)")
  }
}
