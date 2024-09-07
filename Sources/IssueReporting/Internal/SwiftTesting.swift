import Foundation

#if canImport(WinSDK)
  import WinSDK
#endif

@usableFromInline
func _recordIssue(
  message: String?,
  fileID: String = #fileID,
  filePath: String = #filePath,
  line: Int = #line,
  column: Int = #column
) {
  guard let function = function(for: "$s25IssueReportingTestSupport07_recordA0ypyF")
  else {
    #if DEBUG
      guard
        let record = unsafeBitCast(
          symbol: "$s7Testing5IssueV6record_14sourceLocationAcA7CommentVSg_AA06SourceE0VtFZ",
          in: "Testing",
          to: (@convention(thin) (Any?, SourceLocation) -> Issue).self
        )
      else { return }

      var comment: Any?
      if let message {
        var c = UnsafeMutablePointer<Comment>.allocate(capacity: 1).pointee
        c.rawValue = message
        comment = c
      }
      _ = record(
        comment,
        SourceLocation(fileID: fileID, _filePath: filePath, line: line, column: column)
      )
    #else
      printError(
        """
        \(fileID):\(line): An issue was recorded without linking the Testing framework.

        To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
        """
      )
    #endif
    return
  }

  let recordIssue = function as! @Sendable (String?, String, String, Int, Int) -> Void
  recordIssue(message, fileID, filePath, line, column)
}

@usableFromInline
func _recordError(
  error: any Error,
  message: String?,
  fileID: String = #fileID,
  filePath: String = #filePath,
  line: Int = #line,
  column: Int = #column
) {
  guard let function = function(for: "$s25IssueReportingTestSupport12_recordErrorypyF")
  else {
    #if DEBUG
      guard
        let record = unsafeBitCast(
          symbol: """
            $s7Testing5IssueV6record__14sourceLocationACs5Error_p_AA7CommentVSgAA06SourceE0VtFZ
            """,
          in: "Testing",
          to: (@convention(thin) (any Error, Any?, SourceLocation) -> Issue).self
        )
      else { return }

      var comment: Any?
      if let message {
        var c = UnsafeMutablePointer<Comment>.allocate(capacity: 1).pointee
        c.rawValue = message
        comment = c
      }
      _ = record(
        error,
        comment,
        SourceLocation(fileID: fileID, _filePath: filePath, line: line, column: column)
      )
    #else
      printError(
        """
        \(fileID):\(line): An issue was recorded without linking the Testing framework.

        To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
        """
      )
    #endif
    return
  }

  let recordError = function as! @Sendable (any Error, String?, String, String, Int, Int) -> Void
  recordError(error, message, fileID, filePath, line, column)
}

@usableFromInline
func _withKnownIssue(
  _ message: String? = nil,
  isIntermittent: Bool = false,
  fileID: String = #fileID,
  filePath: String = #filePath,
  line: Int = #line,
  column: Int = #column,
  _ body: () throws -> Void
) {
  guard let function = function(for: "$s25IssueReportingTestSupport010_withKnownA0ypyF")
  else {
    #if DEBUG
      guard
        let withKnownIssue = unsafeBitCast(
          symbol: """
            $s7Testing14withKnownIssue_14isIntermittent14sourceLocation_yAA7CommentVSg_SbAA06Source\
            H0VyyKXEtF
            """,
          in: "Testing",
          to: (@convention(thin) (
            Any?,
            Bool,
            SourceLocation,
            () throws -> Void
          ) -> Void)
          .self
        )
      else { return }

      var comment: Any?
      if let message {
        var c = UnsafeMutablePointer<Comment>.allocate(capacity: 1).pointee
        c.rawValue = message
        comment = c
      }
      withKnownIssue(
        comment,
        isIntermittent,
        SourceLocation(fileID: fileID, _filePath: filePath, line: line, column: column),
        body
      )
    #else
      printError(
        """
        \(fileID):\(line): A known issue was recorded without linking the Testing framework.

        To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
        """
      )
    #endif
    return
  }

  let withKnownIssue =
    function
    as! @Sendable (
      String?,
      Bool,
      String,
      String,
      Int,
      Int,
      () throws -> Void
    ) -> Void
  withKnownIssue(message, isIntermittent, fileID, filePath, line, column, body)
}

@usableFromInline
func _withKnownIssue(
  _ message: String? = nil,
  isIntermittent: Bool = false,
  fileID: String = #fileID,
  filePath: String = #filePath,
  line: Int = #line,
  column: Int = #column,
  _ body: () async throws -> Void
) async {
  guard let function = function(for: "$s25IssueReportingTestSupport010_withKnownA5AsyncypyF")
  else {
    #if DEBUG
      guard
        let withKnownIssue = unsafeBitCast(
          symbol: """
            $s7Testing14withKnownIssue_14isIntermittent14sourceLocation_yAA7CommentVSg_SbAA06Source\
            H0VyyYaKXEtYaFTu
            """,
          in: "Testing",
          to: (@convention(thin) (
            Any?,
            Bool,
            SourceLocation,
            () async throws -> Void
          ) async -> Void)
          .self
        )
      else { return }

      var comment: Any?
      if let message {
        var c = UnsafeMutablePointer<Comment>.allocate(capacity: 1).pointee
        c.rawValue = message
        comment = c
      }
      await withKnownIssue(
        comment,
        isIntermittent,
        SourceLocation(fileID: fileID, _filePath: filePath, line: line, column: column),
        body
      )
    #else
      printError(
        """
        \(fileID):\(line): A known issue was recorded without linking the Testing framework.

        To fix this, add "IssueReportingTestSupport" as a dependency to your test target.
        """
      )
    #endif
    return
  }

  let withKnownIssue =
    function
    as! @Sendable (
      String?,
      Bool,
      String,
      String,
      Int,
      Int,
      () async throws -> Void
    ) async -> Void
  await withKnownIssue(message, isIntermittent, fileID, filePath, line, column, body)
}
@usableFromInline
func _currentTestData() -> (id: AnyHashable, isParameterized: Bool)? {
  guard let function = function(for: "$s25IssueReportingTestSupport08_currentC4DataypyF")
  else {
    #if DEBUG
      guard let id = Test.current?.id, let isParameterized = Test.Case.current?.isParameterized
      else { return nil }
      return (id, isParameterized)
    #else
      return nil
    #endif
  }

  return (function as! @Sendable () -> (id: AnyHashable, isParameterized: Bool)?)()
}

#if DEBUG
  #if _runtime(_ObjC)
    import ObjectiveC

    private typealias __XCTestCompatibleSelector = Selector
  #else
    private typealias __XCTestCompatibleSelector = Never
  #endif

  private struct __Expression: Sendable {
    enum Kind: Sendable {
      case generic(_ sourceCode: String)
      case stringLiteral(sourceCode: String, stringValue: String)
      indirect case binaryOperation(lhs: __Expression, `operator`: String, rhs: __Expression)
      struct FunctionCallArgument: Sendable {
        var label: String?
        var value: __Expression
      }
      indirect case functionCall(
        value: __Expression?, functionName: String, arguments: [FunctionCallArgument]
      )
      indirect case propertyAccess(value: __Expression, keyPath: __Expression)
      indirect case negation(_ expression: __Expression, isParenthetical: Bool)
    }
    var kind: Kind
    struct Value: Sendable {
      var description: String
      var debugDescription: String
      var typeInfo: TypeInfo
      var label: String?
      var isCollection: Bool
      var children: [Self]?
    }
    var runtimeValue: Value?
  }

  private struct Backtrace: Sendable {
    typealias Address = UInt64
    var addresses: [Address]
  }

  private struct Comment: RawRepresentable, Sendable {
    var rawValue: String
    init(rawValue: String) {
      self.rawValue = rawValue
      self.kind = nil
    }
    enum Kind: Sendable {
      case line
      case block
      case documentationLine
      case documentationBlock
      case trait
      case stringLiteral
    }
    var kind: Kind?
  }

  private struct Confirmation: Sendable {
  }
  private protocol ExpectedCount: Sendable, RangeExpression<Int> {}

  private struct Expectation: Sendable {
    var evaluatedExpression: __Expression
    var mismatchedErrorDescription: String?
    var differenceDescription: String?
    var mismatchedExitConditionDescription: String?
    var isPassing: Bool
    var isRequired: Bool
    var sourceLocation: SourceLocation
  }

  private struct Issue: Sendable {
    enum Kind: Sendable {
      case unconditional
      indirect case expectationFailed(_ expectation: Expectation)
      indirect case confirmationMiscounted(actual: Int, expected: Int)
      indirect case confirmationOutOfRange(actual: Int, expected: any ExpectedCount)
      indirect case errorCaught(_ error: any Error)
      indirect case timeLimitExceeded(timeLimitComponents: (seconds: Int64, attoseconds: Int64))
      case knownIssueNotRecorded
      case apiMisused
      case system
    }
    var kind: Kind
    var comments: [Comment]
    var sourceContext: SourceContext
  }

  private struct SourceContext: Sendable {
    var backtrace: Backtrace?
    var sourceLocation: SourceLocation?
  }

  private struct SourceLocation: Hashable, Sendable {
    var fileID: String
    var _filePath: String
    var line: Int
    var column: Int
    var moduleName: String {
      let firstSlash = fileID.firstIndex(of: "/")!
      return String(fileID[..<firstSlash])
    }
  }

  private struct Test: @unchecked Sendable {
    fileprivate static var current: Self? {
      guard
        let current = unsafeBitCast(
          symbol: "$s7Testing4TestV7currentACSgvgZ",
          in: "Testing",
          to: (@convention(thin) () -> Test?).self
        )
      else { return nil }
      return current()
    }

    fileprivate struct Case {
      static var current: Self? {
        guard
          let current = unsafeBitCast(
            symbol: "$s7Testing4TestV4CaseV7currentAESgvgZ",
            in: "Testing",
            to: (@convention(thin) () -> Test.Case?).self
          )
        else { return nil }
        return current()
      }

      private var arguments: [Argument]
      private var body: @Sendable () async throws -> Void

      fileprivate var isParameterized: Bool {
        !arguments.isEmpty
      }

      private struct Argument: Sendable {
        var value: any Sendable
        var parameter: Parameter
      }
    }
    private var name: String
    private var displayName: String?
    private var traits: [any Trait]
    private var sourceLocation: SourceLocation
    private var containingTypeInfo: TypeInfo?
    private var xcTestCompatibleSelector: __XCTestCompatibleSelector?
    fileprivate enum TestCasesState: @unchecked Sendable {
      case unevaluated(_ function: @Sendable () async throws -> AnySequence<Test.Case>)
      case evaluated(_ testCases: AnySequence<Test.Case>)
      case failed(_ error: any Error)
    }
    fileprivate var testCasesState: TestCasesState?
    private var parameters: [Parameter]?
    private struct Parameter: Sendable {
      var index: Int
      var firstName: String
      var secondName: String?
      var typeInfo: TypeInfo
    }
    private var isSynthesized = false

    private var isSuite: Bool {
      containingTypeInfo != nil && testCasesState == nil
    }
    fileprivate var id: ID {
      var result =
        containingTypeInfo.map(ID.init)
        ?? ID(moduleName: sourceLocation.moduleName, nameComponents: [], sourceLocation: nil)

      if !isSuite {
        result.nameComponents.append(name)
        result.sourceLocation = sourceLocation
      }

      return result
    }
    fileprivate struct ID: Hashable {
      var moduleName: String
      var nameComponents: [String]
      var sourceLocation: SourceLocation?
      init(moduleName: String, nameComponents: [String], sourceLocation: SourceLocation?) {
        self.moduleName = moduleName
        self.nameComponents = nameComponents
        self.sourceLocation = sourceLocation
      }
      init(_ fullyQualifiedNameComponents: some Collection<String>) {
        moduleName = fullyQualifiedNameComponents.first ?? ""
        if fullyQualifiedNameComponents.count > 0 {
          nameComponents = Array(fullyQualifiedNameComponents.dropFirst())
        } else {
          nameComponents = []
        }
      }
      init(typeInfo: TypeInfo) {
        self.init(typeInfo.fullyQualifiedNameComponents)
      }
    }
  }

  private protocol Trait: Sendable {}

  private struct TypeInfo: Sendable {
    enum _Kind: Sendable {
      case type(_ type: Any.Type)
      case nameOnly(fullyQualifiedComponents: [String], unqualified: String, mangled: String?)
    }
    var _kind: _Kind

    static let _fullyQualifiedNameComponentsCache:
      LockIsolated<
        [ObjectIdentifier: [String]]
      > = LockIsolated([:])
    var fullyQualifiedNameComponents: [String] {
      switch _kind {
      case let .type(type):
        if let cachedResult = Self
          ._fullyQualifiedNameComponentsCache.withLock({ $0[ObjectIdentifier(type)] })
        {
          return cachedResult
        }
        var result = String(reflecting: type)
          .split(separator: ".")
          .map(String.init)
        if let firstComponent = result.first, firstComponent.starts(with: "(extension in ") {
          result[0] = String(firstComponent.split(separator: ":", maxSplits: 1).last!)
        }
        result = result.filter { !$0.starts(with: "(unknown context at") }
        Self._fullyQualifiedNameComponentsCache.withLock { [result] in
          $0[ObjectIdentifier(type)] = result
        }
        return result

      case let .nameOnly(fullyQualifiedComponents, _, _):
        return fullyQualifiedComponents
      }
    }
  }
#endif

@usableFromInline
func function(for symbol: String) -> Any? {
  let function = unsafeBitCast(
    symbol: symbol,
    in: "IssueReportingTestSupport",
    to: (@convention(thin) () -> Any).self
  )
  return function?()
}

@usableFromInline
func unsafeBitCast<F>(symbol: String, in library: String, to function: F.Type) -> F? {
  #if os(Linux)
    guard
      let handle = dlopen("lib\(library).so", RTLD_LAZY),
      let pointer = dlsym(handle, symbol)
    else { return nil }
    return unsafeBitCast(pointer, to: F.self)
  #elseif canImport(Darwin)
    guard
      let handle = dlopen(nil, RTLD_LAZY),
      let pointer = dlsym(handle, symbol)
    else { return nil }
    return unsafeBitCast(pointer, to: F.self)
  #elseif os(Windows)
    guard
      let handle = LoadLibraryA("\(library).dll"),
      let pointer = GetProcAddress(handle, symbol)
    else { return nil }
    return unsafeBitCast(pointer, to: F.self)
  #else
    return nil
  #endif
}
