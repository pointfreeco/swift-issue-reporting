#if DEBUG
  #if canImport(ObjectiveC)
    import Foundation

    var XCTCurrentTestCase: AnyObject? {
      guard
        let XCTestObservationCenter = NSClassFromString("XCTestObservationCenter")
          as Any as? NSObjectProtocol,
        String(describing: XCTestObservationCenter) != "<null>",
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
