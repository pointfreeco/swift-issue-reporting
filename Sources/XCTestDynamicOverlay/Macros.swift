#if swift(>=5.9)
  @attached(accessor, names: named(get), named(set))
  @attached(peer, names: prefixed(`$`))
  public macro DependencyEndpoint() = #externalMacro(
    module: "XCTestDynamicOverlayMacros", type: "DependencyEndpointMacro"
  )
#endif

public struct Endpoint<Value> {
  public var rawValue: Value
  private let _override: (Value) -> Value

  public init(
    initialValue: Value,
    override: @escaping (Value) -> Value
  ) {
    self.rawValue = initialValue
    self._override = override
  }

  public mutating func set(_ operation: Value) {
    self.rawValue = self._override(operation)
  }

  public mutating func callAsFunction(_ operation: Value) {
    self.set(operation)
  }
}
