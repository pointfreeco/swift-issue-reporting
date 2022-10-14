public enum _Flags {
  @TaskLocal public static var disableRuntimeWarnings = false
}

public func disableRuntimeWarnings<R>(_ operation: () throws -> R) rethrows -> R {
  try _Flags.$disableRuntimeWarnings.withValue(true) {
    try operation()
  }
}

public func disableRuntimeWarnings<R>(_ operation: () async throws -> R) async rethrows -> R {
  try await _Flags.$disableRuntimeWarnings.withValue(true) {
    try await operation()
  }
}
