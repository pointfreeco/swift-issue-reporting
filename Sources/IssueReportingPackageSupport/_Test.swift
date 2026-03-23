public struct _Test {
  public let id: AnyHashable
  public let traits: [any Sendable]

  public init(id: AnyHashable, traits: [any Sendable]) {
    self.id = id
    self.traits = traits
  }
}
