public enum XCTestDynamicOverlayFlags {
  @TaskLocal public static var disableRuntimeWarnings = false
}

public func withRuntimeWarningsDisabled<R>(_ operation: () throws -> R) rethrows -> R {
  try XCTestDynamicOverlayFlags.$disableRuntimeWarnings.withValue(true) {
    try operation()
  }
}

public func withRuntimeWarningsDisabled<R>(_ operation: () async throws -> R) async rethrows -> R {
  try await XCTestDynamicOverlayFlags.$disableRuntimeWarnings.withValue(true) {
    try await operation()
  }
}
