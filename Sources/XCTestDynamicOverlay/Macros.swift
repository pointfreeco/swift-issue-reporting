#if swift(>=5.9)
  @attached(accessor, names: named(init), named(get), named(set))
  @attached(peer, names: prefixed(_))
  public macro Unimplemented() = #externalMacro(
    module: "XCTestDynamicOverlayMacros", type: "UnimplementedMacro"
  )

  @attached(accessor, names: named(init), named(get), named(set))
  @attached(peer, names: prefixed(_))
  public macro Unimplemented<T>(default: T) = #externalMacro(
    module: "XCTestDynamicOverlayMacros", type: "UnimplementedMacro"
  )
#endif
