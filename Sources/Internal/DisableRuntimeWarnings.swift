@_spi(Internals)
public enum Flags {
  @TaskLocal public static var disableRuntimeWarnings = false
}

public func disableRuntimeWarnings<R>(_ operation: () throws -> R) rethrows -> R {
  try Flags.$disableRuntimeWarnings.withValue(true) {
    try operation()
  }
}

public func disableRuntimeWarnings<R>(_ operation: () async throws -> R) async rethrows -> R {
  try await Flags.$disableRuntimeWarnings.withValue(true) {
    try await operation()
  }
}
