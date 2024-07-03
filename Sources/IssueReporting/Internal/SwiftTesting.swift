import Foundation

#if _runtime(_ObjC)
  import ObjectiveC

  private typealias __XCTestCompatibleSelector = Selector
#else
  private typealias __XCTestCompatibleSelector = Never
#endif

@usableFromInline
struct Issue {
  @usableFromInline
  static func record(
    _ message: String = "",
    fileID: String = #fileID,
    filePath: String = #filePath,
    line: Int = #line,
    column: Int = #column
  ) {
    guard
      let fromSyntaxNodePtr = dlsym(
        dlopen(nil, RTLD_LAZY),
        "$s7Testing12__ExpressionV16__fromSyntaxNodeyACSSFZ"
      ),
      let checkValuePtr = dlsym(
        dlopen(nil, RTLD_LAZY),
        """
        $s7Testing12__checkValue_10expression0D25WithCapturedRuntimeValues26mismatchedErrorDescript\
        ion10difference8comments10isRequired14sourceLocations6ResultOyyts0J0_pGSb_AA12__ExpressionV\
        AOSgyXKSSSgyXKAQyXKSayAA7CommentVGyXKSbAA06SourceQ0VtF
        """
      )
    else { return }

    let fromSyntaxNode = withUnsafePointer(to: fromSyntaxNodePtr) {
      UnsafeRawPointer($0).assumingMemoryBound(
        to: (@convention(thin) (String) -> __Expression).self
      )
      .pointee(message)
    }

    _ = withUnsafePointer(to: checkValuePtr) {
      UnsafeRawPointer($0).assumingMemoryBound(
        to: (
          @convention(thin) (
            Bool,
            __Expression,
            @autoclosure () -> __Expression?,
            @autoclosure () -> String?,
            @autoclosure () -> String?,
            @autoclosure () -> [Any],
            Bool,
            SourceLocation
          ) -> Result<Void, any Error>
        )
        .self
      )
      .pointee(
        false,
        fromSyntaxNode,
        nil,
        nil,
        nil,
        [],
        false,
        SourceLocation(fileID: fileID, _filePath: filePath, line: line, column: column)
      )
    }
  }
}

@usableFromInline
func withKnownIssue(
  _ message: String? = nil,
  isIntermittent: Bool = false,
  fileID: String = #fileID,
  filePath: String = #filePath,
  line: Int = #line,
  column: Int = #column,
  _ body: () throws -> Void
) {
  guard
    let withKnownIssuePtr = dlsym(
      dlopen(nil, RTLD_LAZY),
      """
      $s7Testing14withKnownIssue_14isIntermittent6fileID0G4Path4line6column_yAA7CommentVSg_SbS2SS2i\
      yyKXEtF
      """
    )
  else { return }

  var comment: Any?
  if let message {
    var c = UnsafeMutablePointer<Comment>.allocate(capacity: 1).pointee
    c.rawValue = message
    comment = c
  }

  withUnsafePointer(to: withKnownIssuePtr) {
    let withKnownIssue = UnsafeRawPointer($0).assumingMemoryBound(
      to: (
        @convention(thin) (
          Any?,
          Bool,
          String,
          String,
          Int,
          Int,
          () throws -> Void
        ) -> Void
      )
      .self
    )
    .pointee
    withKnownIssue(
      comment, isIntermittent, fileID, filePath, line, column, body
    )
  }
}

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

private struct TypeInfo: Sendable {
  enum _Kind: Sendable {
    case type(_ type: Any.Type)
    case nameOnly(fullyQualifiedComponents: [String], unqualified: String, mangled: String?)
  }
  var _kind: _Kind
}

private struct SourceLocation: Sendable {
  var fileID: String
  var _filePath: String
  var line: Int
  var column: Int
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

private protocol Trait: Sendable {}

struct Test: @unchecked Sendable {
  static var current: Self? {
    guard
      let currentPtr = dlsym(
        dlopen(nil, RTLD_LAZY),
        """
        $s7Testing4TestV7currentACSgvgZ
        """
      )
    else { return nil }
    return withUnsafePointer(to: currentPtr) {
      UnsafeRawPointer($0).assumingMemoryBound(to: (@convention(thin) () -> Test?).self).pointee()
    }
  }

  struct Case {}
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
}
