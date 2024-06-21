@usableFromInline
struct UncheckedSendable<Value>: @unchecked Sendable {
  @usableFromInline
  var wrappedValue: Value
  init(_ value: Value) {
    self.wrappedValue = value
  }
}
