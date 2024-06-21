@usableFromInline
struct FailureObserver {
  @usableFromInline
  @TaskLocal static var current: LockIsolated<Self>?
  @usableFromInline
  static var _$current: TaskLocal<LockIsolated<Self>?> { $current }
  @usableFromInline
  var count: Int
  @usableFromInline
  var precondition: Bool
  @usableFromInline
  init(count: Int = 0, precondition: Bool) {
    self.count = count
    self.precondition = precondition
  }
}
