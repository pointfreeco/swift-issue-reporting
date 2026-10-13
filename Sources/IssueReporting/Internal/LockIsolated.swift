import Foundation

@usableFromInline
final class LockIsolated<Value>: @unchecked Sendable {
  private var _value: Value
  private let lock = NSLock()
  @usableFromInline
  init(_ value: sending Value) {
    self._value = value
  }
  #if compiler(>=6.3)
    @usableFromInline
    func withLock<T>(
      _ operation: sending (inout sending Value) throws -> sending T
    ) rethrows -> sending T {
      lock.lock()
      defer { lock.unlock() }
      var value = _value
      defer { _value = value }
      return try operation(&value)
    }
  #else
    @usableFromInline
    func withLock<T>(
      _ operation: @Sendable (inout Value) throws -> T
    ) rethrows -> sending T {
      lock.lock()
      defer { lock.unlock() }
      var value = _value
      defer { _value = value }
      return try operation(&value)
    }
  #endif
}
