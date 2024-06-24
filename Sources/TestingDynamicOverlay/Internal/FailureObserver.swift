@usableFromInline
struct FailureObserver {
  @usableFromInline
  @TaskLocal static var current: LockIsolated<Self>?
  @usableFromInline
  static var _$current: TaskLocal<LockIsolated<Self>?> { $current }
  @usableFromInline
  var count: Int
  @usableFromInline
  init(count: Int = 0) {
    self.count = count
  }
}
