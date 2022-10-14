@_spi(Internals)
public enum Flags {
  @TaskLocal public static var disableRuntimeWarnings = false
}

public func disableRuntimeWarnings(_ operation: () throws -> Void) rethrows {
  try Flags.$disableRuntimeWarnings.withValue(true) {
    try operation()
  }
}

public func disableRuntimeWarnings(_ operation: () async throws -> Void) async rethrows {
  try await Flags.$disableRuntimeWarnings.withValue(true) {
    try await operation()
  }
}
