import Foundation

#if canImport(ObjectiveC)
  /// Instructs the test to expect a failure in an upcoming assertion, with options to customize
  /// expected failure checking and handling.
  ///
  /// - Parameters:
  ///   - failureReason: An optional string that describes why the test expects a failure.
  ///   - enabled: A Boolean value that indicates whether the test checks for the expected failure.
  ///   - strict: A Boolean value that indicates whether the test reports an error if the expected
  ///     failure doesn’t occur.
  ///   - failingBlock: A block of test code and assertions where the test expects a failure.
  @_disfavoredOverload
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
      let errorString = dlerror().map { charPointer in String(cString: charPointer) }
        ?? "Unknown error"
      assertionFailure(
        "Failed to get symbol for XCTExpectFailureWithOptionsInBlock with error: \(errorString)."
      )
      return try failingBlock()
    }

    if let issueMatcher = issueMatcher {
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

  /// Instructs the test to expect a failure in an upcoming assertion, with options to customize
  /// expected failure checking and handling.
  ///
  /// - Parameters:
  ///   - failureReason: An optional string that describes why the test expects a failure.
  ///   - enabled: A Boolean value that indicates whether the test checks for the expected failure.
  ///   - strict: A Boolean value that indicates whether the test reports an error if the expected
  ///     failure doesn’t occur.
  @_disfavoredOverload
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
      let errorString = dlerror().map { charPointer in String(cString: charPointer) }
        ?? "Unknown error"
      assertionFailure(
        "Failed to get symbol for XCTExpectFailureWithOptionsInBlock with error: \(errorString)."
      )
      return
    }

    if let issueMatcher = issueMatcher {
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

  public struct _XCTIssue: /*CustomStringConvertible, */Equatable, Hashable {
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

  @rethrows
  private protocol _ErrorMechanism {
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
#endif
