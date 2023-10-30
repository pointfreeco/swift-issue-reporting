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
          @storageRestrictions(initializes: $endpoint)
          init(initialValue) {
            $endpoint = Endpoint(initialValue: initialValue) {
              $0
            }
          }
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
          @storageRestrictions(initializes: $endpoint)
          init(initialValue) {
            $endpoint = Endpoint(initialValue: initialValue) {
              $0
            }
          }
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
          @storageRestrictions(initializes: $endpoint)
          init(initialValue) {
            $endpoint = Endpoint(initialValue: initialValue) {
              $0
            }
          }
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
          @storageRestrictions(initializes: $endpoint)
          init(initialValue) {
            $endpoint = Endpoint(initialValue: initialValue) {
              $0
            }
          }
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
          @storageRestrictions(initializes: $endpoint)
          init(initialValue) {
            $endpoint = Endpoint(initialValue: initialValue) {
              $0
            }
          }
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

  func testTupleReturnValue() {
    assertMacro {
      """
      public struct ApiClient {
        @DependencyEndpoint
        public var apiRequest: @Sendable (ServerRoute.Api.Route) async throws -> (Data, URLResponse)
      }
      """
    } expansion: {
      """
      public struct ApiClient {
        public var apiRequest: @Sendable (ServerRoute.Api.Route) async throws -> (Data, URLResponse) {
          @storageRestrictions(initializes: $apiRequest)
          init(initialValue) {
            $apiRequest = Endpoint(initialValue: initialValue) {
              $0
            }
          }
          get {
            $apiRequest.rawValue
          }
          set {
            $apiRequest.rawValue = newValue
          }
        }

        var $apiRequest = Endpoint<@Sendable (ServerRoute.Api.Route) async throws -> (Data, URLResponse)>(
          initialValue: { _ in
            XCTestDynamicOverlay.XCTFail("Unimplemented: 'apiRequest'")
            throw XCTestDynamicOverlay.Unimplemented("apiRequest")
          }
        ) { newValue in
          let implemented = _$Implemented("apiRequest")
          return {
            implemented.fulfill()
            return try await newValue($0)
          }
        }
      }
      """
    }
  }

  func testVoidTupleReturnValue() {
    assertMacro {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: () -> ()
      }
      """
    } expansion: {
      """
      struct Client {
        var endpoint: () -> () {
          @storageRestrictions(initializes: $endpoint)
          init(initialValue) {
            $endpoint = Endpoint(initialValue: initialValue) {
              $0
            }
          }
          get {
            $endpoint.rawValue
          }
          set {
            $endpoint.rawValue = newValue
          }
        }

        var $endpoint = Endpoint<() -> ()>(
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

  func testOptionalReturnValue() {
    assertMacro {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: () -> Int?
      }
      """
    } expansion: {
      """
      struct Client {
        var endpoint: () -> Int? {
          @storageRestrictions(initializes: $endpoint)
          init(initialValue) {
            $endpoint = Endpoint(initialValue: initialValue) {
              $0
            }
          }
          get {
            $endpoint.rawValue
          }
          set {
            $endpoint.rawValue = newValue
          }
        }

        var $endpoint = Endpoint<() -> Int?>(
          initialValue: {
            XCTestDynamicOverlay.XCTFail("Unimplemented: 'endpoint'")
            return nil
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

  func testExplicitOptionalReturnValue() {
    assertMacro {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: () -> Optional<Int>
      }
      """
    } expansion: {
      """
      struct Client {
        var endpoint: () -> Optional<Int> {
          @storageRestrictions(initializes: $endpoint)
          init(initialValue) {
            $endpoint = Endpoint(initialValue: initialValue) {
              $0
            }
          }
          get {
            $endpoint.rawValue
          }
          set {
            $endpoint.rawValue = newValue
          }
        }

        var $endpoint = Endpoint<() -> Optional<Int>>(
          initialValue: {
            XCTestDynamicOverlay.XCTFail("Unimplemented: 'endpoint'")
            return nil
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

  func testSendableClosure() {
    assertMacro(record: true) {
      """
      struct Client {
        @DependencyEndpoint
        var endpoint: @Sendable (Int) -> Void
      }
      """
    } expansion: {
      """
      struct Client {
        var endpoint: @Sendable (Int) -> Void {
          @storageRestrictions(initializes: $endpoint)
          init(initialValue) {
            $endpoint = Endpoint(initialValue: initialValue) {
              $0
            }
          }
          get {
            $endpoint.rawValue
          }
          set {
            $endpoint.rawValue = newValue
          }
        }

        var $endpoint = Endpoint<@Sendable (Int) -> Void>(
          initialValue: { _ in
            XCTestDynamicOverlay.XCTFail("Unimplemented: 'endpoint'")
          }
        ) { newValue in
          let implemented = _$Implemented("endpoint")
          return {
            implemented.fulfill()
            newValue($0)
          }
        }
      }
      """
    }
  }
}
