import MacroTesting
import XCTest
import XCTestDynamicOverlayMacros

final class DependencyEndpointMacroTests: XCTestCase {
  override func invokeTest() {
    withMacroTesting(
      // isRecording: true,
      macros: [DependencyEndpointMacro.self]
    ) {
      super.invokeTest()
    }
  }

  func testBasics() {
    assertMacro {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: () -> Void
      }
      """
    } expansion: {
      """
      struct Client {
        var endpoint: () -> Void {
          get {
            $endpoint.rawValue
          }
          set {
            $endpoint.rawValue = newValue
          }
        }

        var $endpoint = Endpoint<() -> Void>(
          initialValue: {
            XCTestDynamicOverlay.XCTFail("Unimplemented: 'endpoint'")
          }
        ) { newValue in
          let implemented = _$Implemented("endpoint")
          return {
            implemented.fulfill()
            newValue()
          }
        }
      }
      """
    }
  }

  func testInitialValue() {
    assertMacro {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: () -> Bool = { _ in false }
      }
      """
    } expansion: {
      """
      struct Client {
        var endpoint: () -> Bool = { _ in false } {
          get {
            $endpoint.rawValue
          }
          set {
            $endpoint.rawValue = newValue
          }
        }

        var $endpoint = Endpoint<() -> Bool>(
          initialValue: { _ in
            XCTestDynamicOverlay.XCTFail("Unimplemented: 'endpoint'")
            return false
          }
        ) { newValue in
          let implemented = _$Implemented("endpoint")
          return {
            implemented.fulfill()
            return newValue()
          }
        }
      }
      """
    }
  }

  func testMissingInitialValue() {
    assertMacro {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: () -> Bool
      }
      """
    } diagnostics: {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: () -> Bool
            ┬───────────────────
            ╰─ 🛑 Missing initial value for non-throwing 'endpoint'
               ✏️ Insert '= { <#Bool#> }'
      }
      """
    }fixes: {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: () -> Bool = { <#Bool#> }
      }
      """
    } expansion: {
      """
      struct Client {
        var endpoint: () -> Bool = { <#Bool#> } {
          get {
            $endpoint.rawValue
          }
          set {
            $endpoint.rawValue = newValue
          }
        }

        var $endpoint = Endpoint<() -> Bool>(
          initialValue: {
            XCTestDynamicOverlay.XCTFail("Unimplemented: 'endpoint'")
            return <#Bool#>
          }
        ) { newValue in
          let implemented = _$Implemented("endpoint")
          return {
            implemented.fulfill()
            return newValue()
          }
        }
      }
      """
    }
  }

  func testMissingInitialValue_Arguments() {
    assertMacro {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: (Int, Bool, String) -> Bool
      }
      """
    } diagnostics: {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: (Int, Bool, String) -> Bool
            ┬────────────────────────────────────
            ╰─ 🛑 Missing initial value for non-throwing 'endpoint'
               ✏️ Insert '= { _, _, _ in <#Bool#> }'
      }
      """
    } fixes: {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: (Int, Bool, String) -> Bool = { _, _, _ in <#Bool#> }
      }
      """
    } expansion: {
      """
      struct Client {
        var endpoint: (Int, Bool, String) -> Bool = { _, _, _ in <#Bool#> } {
          get {
            $endpoint.rawValue
          }
          set {
            $endpoint.rawValue = newValue
          }
        }

        var $endpoint = Endpoint<(Int, Bool, String) -> Bool>(
          initialValue: { _, _, _ in
            XCTestDynamicOverlay.XCTFail("Unimplemented: 'endpoint'")
            return <#Bool#>
          }
        ) { newValue in
          let implemented = _$Implemented("endpoint")
          return {
            implemented.fulfill()
            return newValue($0, $1, $2)
          }
        }
      }
      """
    }
  }

  func testMissingInitialValue_Throwing() {
    assertMacro {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: () throws -> Bool
      }
      """
    } expansion: {
      """
      struct Client {
        var endpoint: () throws -> Bool {
          get {
            $endpoint.rawValue
          }
          set {
            $endpoint.rawValue = newValue
          }
        }

        var $endpoint = Endpoint<() throws -> Bool>(
          initialValue: {
            XCTestDynamicOverlay.XCTFail("Unimplemented: 'endpoint'")
            throw XCTestDynamicOverlay.Unimplemented("endpoint")
          }
        ) { newValue in
          let implemented = _$Implemented("endpoint")
          return {
            implemented.fulfill()
            return try newValue()
          }
        }
      }
      """
    }
  }
}
