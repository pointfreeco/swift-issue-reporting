import Foundation

// Deprecated after 1.1.2:

// Soft-deprecated:

@_disfavoredOverload
@available(iOS, deprecated: 9999, renamed: "fail")
@available(macOS, deprecated: 9999, renamed: "fail")
@available(tvOS, deprecated: 9999, renamed: "fail")
@available(watchOS, deprecated: 9999, renamed: "fail")
public func XCTFail(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
  reportIssue(
    message,
    filePath: XCTFailContext.current?.file ?? file,
    line: XCTFailContext.current?.line ?? line
  )
}

@available(iOS, deprecated: 9999, renamed: "IssueContext")
@available(macOS, deprecated: 9999, renamed: "IssueContext")
@available(tvOS, deprecated: 9999, renamed: "IssueContext")
@available(watchOS, deprecated: 9999, renamed: "IssueContext")
public struct XCTFailContext: Sendable {
  @TaskLocal public static var current: Self?

  public var file: StaticString
  public var line: UInt

  public init(file: StaticString, line: UInt) {
    self.file = file
    self.line = line
  }
}

@available(iOS, deprecated: 9999, renamed: "isTesting")
@available(macOS, deprecated: 9999, renamed: "isTesting")
@available(tvOS, deprecated: 9999, renamed: "isTesting")
@available(watchOS, deprecated: 9999, renamed: "isTesting")
public var _XCTIsTesting: Bool {
  isTesting
}

#if _runtime(_ObjC)
  @_disfavoredOverload
  @available(iOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(macOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(tvOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(watchOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  public func XCTExpectFailure<R>(
    _ failureReason: String? = nil,
    enabled: Bool? = nil,
    strict: Bool? = nil,
    failingBlock: () throws -> R,
    issueMatcher: ((_XCTIssue) -> Bool)? = nil
  ) rethrows -> R {
    guard enabled ?? true
    else { return try failingBlock() }
    guard
      let XCTExpectedFailureOptions = NSClassFromString("XCTExpectedFailureOptions")
        as Any as? NSObjectProtocol,
      let options = strict ?? true
        ? XCTExpectedFailureOptions
          .perform(NSSelectorFromString("alloc"))?.takeUnretainedValue()
          .perform(NSSelectorFromString("init"))?.takeUnretainedValue()
        : XCTExpectedFailureOptions
          .perform(NSSelectorFromString("nonStrictOptions"))?.takeUnretainedValue(),
      let functionBlockPointer = dlsym(dlopen(nil, RTLD_LAZY), "XCTExpectFailureWithOptionsInBlock")
    else {
      let errorString =
        dlerror().map { charPointer in String(cString: charPointer) }
        ?? "Unknown error"
      assertionFailure(
        "Failed to get symbol for XCTExpectFailureWithOptionsInBlock with error: \(errorString)."
      )
      return try failingBlock()
    }

    if let issueMatcher {
      let issueMatcher: @convention(block) (AnyObject) -> Bool = { issue in
        issueMatcher(_XCTIssue(issue))
      }
      options.setValue(issueMatcher, forKey: "issueMatcher")
    }

    let XCTExpectFailureWithOptionsInBlock = unsafeBitCast(
      functionBlockPointer,
      to: (@convention(c) (String?, AnyObject, () -> Void) -> Void).self
    )

    var result: Result<R, Error>!
    XCTExpectFailureWithOptionsInBlock(failureReason, options) {
      result = Result { try failingBlock() }
    }
    return try result._rethrowGet()
  }

  @rethrows
  @usableFromInline
  protocol _ErrorMechanism {
    associatedtype Output
    func get() throws -> Output
  }
  extension _ErrorMechanism {
    func _rethrowError() rethrows -> Never {
      _ = try _rethrowGet()
      fatalError()
    }
    @usableFromInline
    func _rethrowGet() rethrows -> Output {
      return try get()
    }
  }
  extension Result: _ErrorMechanism {}

  @_disfavoredOverload
  @available(iOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(macOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(tvOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  @available(watchOS, deprecated: 9999, message: "Use 'withKnownFailure', instead.")
  public func XCTExpectFailure(
    _ failureReason: String? = nil,
    enabled: Bool? = nil,
    strict: Bool? = nil,
    issueMatcher: ((_XCTIssue) -> Bool)? = nil
  ) {
    guard enabled ?? true
    else { return }
    guard
      let XCTExpectedFailureOptions = NSClassFromString("XCTExpectedFailureOptions")
        as Any as? NSObjectProtocol,
      let options = strict ?? true
        ? XCTExpectedFailureOptions
          .perform(NSSelectorFromString("alloc"))?.takeUnretainedValue()
          .perform(NSSelectorFromString("init"))?.takeUnretainedValue()
        : XCTExpectedFailureOptions
          .perform(NSSelectorFromString("nonStrictOptions"))?.takeUnretainedValue(),
      let functionBlockPointer = dlsym(dlopen(nil, RTLD_LAZY), "XCTExpectFailureWithOptions")
    else {
      let errorString =
        dlerror().map { charPointer in String(cString: charPointer) }
        ?? "Unknown error"
      assertionFailure(
        "Failed to get symbol for XCTExpectFailureWithOptionsInBlock with error: \(errorString)."
      )
      return
    }

    if let issueMatcher {
      let issueMatcher: @convention(block) (AnyObject) -> Bool = { issue in
        issueMatcher(_XCTIssue(issue))
      }
      options.setValue(issueMatcher, forKey: "issueMatcher")
    }

    let XCTExpectFailureWithOptions = unsafeBitCast(
      functionBlockPointer,
      to: (@convention(c) (String?, AnyObject) -> Void).self
    )

    XCTExpectFailureWithOptions(failureReason, options)
  }

  @available(iOS, deprecated: 9999)
  @available(macOS, deprecated: 9999)
  @available(tvOS, deprecated: 9999)
  @available(watchOS, deprecated: 9999)
  public struct _XCTIssue: /*CustomStringConvertible, */ Equatable, Hashable {
    public var type: IssueType
    public var compactDescription: String
    public var detailedDescription: String?

    // NB: This surface are has been left unimplemented for now. We can consider adopting more of it
    //     in the future:
    //
    // var sourceCodeContext: XCTSourceCodeContext
    // var associatedError: Error?
    // var attachments: [XCTAttachment]
    // mutating func add(XCTAttachment)
    //
    // public var description: String {
    //   """
    //   \(self.type.description) \
    //   at \
    //   \(self.sourceCodeContext.location.fileURL.lastPathComponent):\
    //   \(self.sourceCodeContext.location.lineNumber): \
    //   \(self.compactDescription)
    //   """
    // }

    init(_ issue: AnyObject) {
      self.type = IssueType(rawValue: issue.value(forKey: "type") as! Int)!
      self.compactDescription = issue.value(forKey: "compactDescription") as! String
      self.detailedDescription = issue.value(forKey: "detailedDescription") as? String
    }

    public enum IssueType: Int, Sendable {
      case assertionFailure = 0
      case performanceRegression = 3
      case system = 4
      case thrownError = 1
      case uncaughtException = 2
      case unmatchedExpectedFailure = 5

      var description: String {
        switch self {
        case .assertionFailure:
          return "Assertion Failure"
        case .performanceRegression:
          return "Performance Regression"
        case .system:
          return "System Error"
        case .thrownError:
          return "Thrown Error"
        case .uncaughtException:
          return "Uncaught Exception"
        case .unmatchedExpectedFailure:
          return "Unmatched ExpectedFailure"
        }
      }
    }
  }
#endif

@_spi(CurrentTestCase)
@available(iOS, deprecated: 9999)
@available(macOS, deprecated: 9999)
@available(tvOS, deprecated: 9999)
@available(watchOS, deprecated: 9999)
public var XCTCurrentTestCase: AnyObject? {
  #if _runtime(_ObjC)
    guard
      let XCTestObservationCenter = NSClassFromString("XCTestObservationCenter"),
      let XCTestObservationCenter = XCTestObservationCenter as Any as? NSObjectProtocol,
      let shared = XCTestObservationCenter.perform(Selector(("sharedTestObservationCenter")))?
        .takeUnretainedValue(),
      let observers = shared.perform(Selector(("observers")))?
        .takeUnretainedValue() as? [AnyObject],
      let observer =
        observers
        .first(where: { NSStringFromClass(type(of: $0)) == "XCTestMisuseObserver" }),
      let currentTestCase = observer.perform(Selector(("currentTestCase")))?
        .takeUnretainedValue()
    else { return nil }
    return currentTestCase
  #else
    return nil
  #endif
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () -> Result {
  return {
    _fail(description(), nil, fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () -> Result {
  return {
    let description = description()
    _fail(description, nil, fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
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

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
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

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) -> Result {
  return {
    _fail(description(), $0, fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) -> Result {
  return {
    let description = description()
    _fail(description, $0, fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) -> Result {
  return {
    _fail(description(), ($0, $1), fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1), fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) -> Result {
  return {
    _fail(description(), ($0, $1, $2), fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2), fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) -> Result {
  return {
    _fail(description(), ($0, $1, $2, $3), fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3), fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) -> Result {
  return {
    _fail(description(), ($0, $1, $2, $3, $4), fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3, $4), fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () throws -> Result {
  return {
    let description = description()
    _fail(description, nil, fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) throws -> Result {
  return {
    let description = description()
    _fail(description, $0, fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1), fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2), fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3), fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3, $4), fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () async -> Result {
  return {
    _fail(description(), nil, fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () async -> Result {
  return {
    let description = description()
    _fail(description, nil, fileID: fileID, line: line)
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
@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) async -> Result {
  return {
    _fail(description(), $0, fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) async -> Result {
  return {
    let description = description()
    _fail(description, $0, fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) async -> Result {
  return {
    _fail(description(), ($0, $1), fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) async -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1), fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) async -> Result {
  return {
    _fail(description(), ($0, $1, $2), fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) async -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2), fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) async -> Result {
  return {
    _fail(description(), ($0, $1, $2, $3), fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) async -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3), fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) async -> Result {
  return {
    _fail(description(), ($0, $1, $2, $3, $4), fileID: fileID, line: line)
    return placeholder()
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) async -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3, $4), fileID: fileID, line: line)
    do {
      return try _generatePlaceholder()
    } catch {
      _unimplementedFatalError(description, file: file, line: line)
    }
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable () async throws -> Result {
  return {
    let description = description()
    _fail(description, nil, fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

/// Returns a closure that generates a failure when invoked.
///
/// - Parameter description: An optional description of the unimplemented closure, for inclusion in
///   test results.
/// - Returns: A closure that generates a failure and throws an error when invoked.
@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A) async throws -> Result {
  return {
    let description = description()
    _fail(description, $0, fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1), fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2), fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3), fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
public func unimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  fileID: StaticString = #fileID,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) async throws -> Result {
  return {
    let description = description()
    _fail(description, ($0, $1, $2, $3, $4), fileID: fileID, line: line)
    throw UnimplementedFailure(description: description)
  }
}

/// An error thrown from ``XCTUnimplemented(_:)-3obl5``.
@available(
  iOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  macOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  tvOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
@available(
  watchOS,
  deprecated: 9999,
  message:
    "'unimplemented' has been deprecated in favor of '@DependencyClient' and '@DependencyEndpoint' from the 'swift-dependencies' package. See https://github.com/pointfreeco/swift-dependencies for more information."
)
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

// Hard-deprecated:

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable () -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable () -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A) -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B) -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C) -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D) -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D, E) -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) -> Result {
  unimplemented(description(), file: file, line: line)
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable () throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A) throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B) throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C) throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D) throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D, E) throws -> Result {
  unimplemented(description())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable () async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable () async -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A) async -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B) async -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C) async -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D) async -> Result {
  unimplemented(description(), file: file, line: line)
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  placeholder: @autoclosure @escaping @Sendable () -> Result
) -> @Sendable (A, B, C, D, E) async -> Result {
  unimplemented(description(), placeholder: placeholder())
}

@_disfavoredOverload
@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (A, B, C, D, E) async -> Result {
  unimplemented(description(), file: file, line: line)
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable () async throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A) async throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B) async throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C) async throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D) async throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "unimplemented")
public func XCTUnimplemented<A, B, C, D, E, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = ""
) -> @Sendable (A, B, C, D, E) async throws -> Result {
  unimplemented(description())
}

@available(*, deprecated, renamed: "UnimplementedFailure")
public typealias XCTUnimplementedFailure = UnimplementedFailure

protocol _DefaultInitializable {
  init()
}

extension Array: _DefaultInitializable {}
extension Bool: _DefaultInitializable {}
extension Character: _DefaultInitializable { init() { self.init(" ") } }
extension Dictionary: _DefaultInitializable {}
extension Double: _DefaultInitializable {}
extension Float: _DefaultInitializable {}
extension Int: _DefaultInitializable {}
extension Int8: _DefaultInitializable {}
extension Int16: _DefaultInitializable {}
extension Int32: _DefaultInitializable {}
extension Int64: _DefaultInitializable {}
extension Set: _DefaultInitializable {}
extension String: _DefaultInitializable {}
extension Substring: _DefaultInitializable {}
extension UInt: _DefaultInitializable {}
extension UInt8: _DefaultInitializable {}
extension UInt16: _DefaultInitializable {}
extension UInt32: _DefaultInitializable {}
extension UInt64: _DefaultInitializable {}

extension AsyncStream: _DefaultInitializable {
  init() { self.init { $0.finish() } }
}

extension AsyncThrowingStream: _DefaultInitializable where Failure == Error {
  init() { self.init { $0.finish(throwing: CancellationError()) } }
}

#if canImport(Foundation)
  import Foundation
  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif

  extension Data: _DefaultInitializable {}
  extension Date: _DefaultInitializable {}
  extension Decimal: _DefaultInitializable {}
  extension UUID: _DefaultInitializable {}
  extension URL: _DefaultInitializable { init() { self.init(string: "/")! } }
#endif

extension _DefaultInitializable { fileprivate static var placeholder: Self { Self() } }
extension AdditiveArithmetic { fileprivate static var placeholder: Self { .zero } }
extension ExpressibleByArrayLiteral { fileprivate static var placeholder: Self { [] } }
extension ExpressibleByBooleanLiteral { fileprivate static var placeholder: Self { false } }
extension ExpressibleByDictionaryLiteral { fileprivate static var placeholder: Self { [:] } }
extension ExpressibleByFloatLiteral { fileprivate static var placeholder: Self { 0.0 } }
extension ExpressibleByIntegerLiteral { fileprivate static var placeholder: Self { 0 } }
extension ExpressibleByUnicodeScalarLiteral { fileprivate static var placeholder: Self { " " } }
extension RangeReplaceableCollection { fileprivate static var placeholder: Self { Self() } }

private protocol _OptionalProtocol { static var none: Self { get } }
extension Optional: _OptionalProtocol {}
private func _optionalPlaceholder<Result>() throws -> Result {
  if let result = (Result.self as? _OptionalProtocol.Type) {
    return result.none as! Result
  }
  throw PlaceholderGenerationFailure()
}

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

struct PlaceholderGenerationFailure: Error {}
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
