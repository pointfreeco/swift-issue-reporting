#if DEBUG
  #if canImport(ObjectiveC)
    import Foundation

    @_spi(CurrentTestCase) public var XCTCurrentTestCase: AnyObject? {
      guard
        let XCTestObservationCenter = NSClassFromString("XCTestObservationCenter"),
        let XCTestObservationCenter = XCTestObservationCenter as Any as? NSObjectProtocol,
        let shared = XCTestObservationCenter.perform(Selector(("sharedTestObservationCenter")))?
          .takeUnretainedValue(),
        let observers = shared.perform(Selector(("observers")))?
          .takeUnretainedValue() as? [AnyObject],
        let observer =
          observers
          .first(where: { NSStringFromClass(type(of: $0)) == "XCTestMisuseObserver" }),
        let currentTestCase = observer.perform(Selector(("currentTestCase")))?
          .takeUnretainedValue()
      else { return nil }
      return currentTestCase
    }
  #else
    var XCTCurrentTestCase: AnyObject? {
      nil
    }
  #endif
#else
  var XCTCurrentTestCase: AnyObject? {
    nil
  }
#endif
