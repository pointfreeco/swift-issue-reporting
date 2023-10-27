import SwiftDiagnostics
import SwiftOperators
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum UnimplementedMacro {
}

extension UnimplementedMacro: AccessorMacro {
  public static func expansion<D: DeclSyntaxProtocol, C: MacroExpansionContext>(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: D,
    in context: C
  ) throws -> [AccessorDeclSyntax] {
    guard
      let property = declaration.as(VariableDeclSyntax.self),
      let binding = property.bindings.first,
      let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
      let type = binding.typeAnnotation?.type,
      let functionType = type.as(FunctionTypeSyntax.self)
        ?? type.as(AttributedTypeSyntax.self)?.baseType.as(FunctionTypeSyntax.self),
      let functionReturnType = functionType.returnClause.type.as(IdentifierTypeSyntax.self)
    else {
      context.diagnose(
        Diagnostic(
          node: node,
          message: SimpleDiagnosticMessage(
            message: """
              '@Unimplemented' must be attached to closure property
              """,
            diagnosticID: "closure-property",
            severity: .error
          )
        )
      )
      return []
    }

    var effectSpecifiers = ""
    if functionType.effectSpecifiers?.throwsSpecifier != nil {
      effectSpecifiers.append("try ")
    }
    if functionType.effectSpecifiers?.asyncSpecifier != nil {
      effectSpecifiers.append("await ")
    }
    let parameterList = (0..<functionType.parameters.count).map { "$\($0)" }.joined(separator: ", ")

    return [
      """
      @storageRestrictions(initializes: _\(identifier))
      init(initialValue) {
        _\(identifier) = initialValue
      }
      """,
      """
      get {
        _\(identifier)
      }
      """,
      // FIXME: Can't always use `_$Implemented` in setter
      // Instead we should add another member, _e.g._ `model.$onMeetingEnded.spy { … }`
      """
      set {
        let implemented = _$Implemented("\(identifier)")
        _\(identifier) = {
          implemented.fulfill()
          return \(raw: effectSpecifiers)newValue(\(raw: parameterList))
        }
      }
      """,
    ]
  }
}

extension UnimplementedMacro: PeerMacro {
  public static func expansion<D: DeclSyntaxProtocol, C: MacroExpansionContext>(
    of node: AttributeSyntax,
    providingPeersOf declaration: D,
    in context: C
  ) throws -> [DeclSyntax] {
    guard
      let property = declaration.as(VariableDeclSyntax.self),
      let binding = property.bindings.first,
      let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
      let type = binding.typeAnnotation?.type,
      let functionType = type.as(FunctionTypeSyntax.self)
        ?? type.as(AttributedTypeSyntax.self)?.baseType.as(FunctionTypeSyntax.self),
      let functionReturnType = functionType.returnClause.type.as(IdentifierTypeSyntax.self)
    else {
      return []
    }

    if let initializer = binding.initializer {
      context.diagnose(
        Diagnostic(
          node: initializer,
          message: SimpleDiagnosticMessage(
            message: """
              '@Unimplemented' property must not have initial value
              """,
            diagnosticID: "closure-property",
            severity: .error
          ),
          fixIt: FixIt(
            message: SimpleFixItMessage(
              message: """
                Remove initial value
                """,
              fixItID: "remove-initial-value"
            ),
            changes: [
              .replace(
                oldNode: Syntax(binding),
                newNode: Syntax(
                  binding
                    .with(\.initializer, nil)
                )
              )
            ]
          )
        )
      )
      return []
    }

    let parameterList =
      functionType.parameters.isEmpty
      ? ""
      : " \((1...functionType.parameters.count).map { _ in "_" }.joined(separator: ", ")) in"

    let terminator: String
    if functionReturnType.name.text == "Void" || functionReturnType.name.text == "()" {
      terminator = ""
    } else if case let .argumentList(arguments) = node.arguments,
      let defaultArgument = arguments.first(where: { $0.label?.text == "default" })
    {
      terminator = """

        return \(defaultArgument.expression.trimmed)
        """
    } else if functionType.effectSpecifiers?.throwsSpecifier != nil {
      terminator = """

        throw XCTestDynamicOverlay.Unimplemented("\(identifier)")
        """
    } else {
      context.diagnose(
        Diagnostic(
          node: node,
          position: node.endPositionBeforeTrailingTrivia,
          message: SimpleDiagnosticMessage(
            message: """
              Missing argument for parameter 'default' in call
              """,
            diagnosticID: "missing-default",
            severity: .error
          ),
          fixIt: FixIt(
            message: SimpleFixItMessage(
              message: """
                Insert 'default: <#\(functionReturnType.name.text)#>'
                """,
              fixItID: "add-missing-default"
            ),
            changes: [
              .replace(
                oldNode: Syntax(node),
                newNode: Syntax(
                  node
                    .with(\.leftParen, .leftParenToken())
                    .with(
                      \.arguments,
                      .argumentList([
                        LabeledExprSyntax(
                          label: "default",
                          expression: EditorPlaceholderExprSyntax(
                            placeholder: TokenSyntax(stringLiteral: "<#\(functionReturnType.name)#>")
                          )
                          .with(\.leadingTrivia, .space)
                        )
                      ])
                    )
                    .with(\.rightParen, .rightParenToken())
                )
              )
            ]
          )
        )
      )
      return []
      // TODO: Should we fatal error instead?
      // terminator = """
      //
      //   Swift.fatalError("Unimplemented: '\(identifier)'")
      //   """
    }

    // TODO: Could add '@ObservationStateIgnored' but would need to export Observation
    return [
      """
      private var _\(binding) = {\(raw: parameterList)
      XCTestDynamicOverlay.XCTFail("Unimplemented: '\(identifier)'")\(raw: terminator)
      }
      """
    ]
  }
}

struct SimpleDiagnosticMessage: DiagnosticMessage {
  var message: String
  var diagnosticID: MessageID
  var severity: DiagnosticSeverity

  init(message: String, diagnosticID: String, severity: DiagnosticSeverity) {
    self.message = message
    self.diagnosticID = MessageID(
      domain: "co.pointfree.xctest-dynamic-overlay",
      id: diagnosticID
    )
    self.severity = severity
  }
}

struct SimpleFixItMessage: FixItMessage {
  var message: String
  var fixItID: MessageID

  init(message: String, fixItID: String) {
    self.message = message
    self.fixItID = MessageID(domain: "co.pointfree.xctest-dynamic-overlay", id: fixItID)
  }
}

extension FunctionTypeSyntax {
  func unimplementedClosure(_ name: String) -> String {
    let parameterList =
      self.parameters.isEmpty
      ? ""
      : " \((1...self.parameters.count).map { _ in "_" }.joined(separator: ", ")) in "

    return "{\(parameterList)}"
  }
}

extension SyntaxStringInterpolation {
  mutating func appendInterpolation<Node: SyntaxProtocol>(_ node: Node?) {
    if let node {
      self.appendInterpolation(node)
    }
  }
}
