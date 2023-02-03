import XCTest
@testable import XCTestDynamicOverlay

final class HostAppCallStackTests: XCTestCase {
  func testIsAbleToDetectT_est() {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackTests.self)
    )
  }

  func testIsAbleToDetectT_estAsync() async {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackTests.self)
    )
  }
}

final class HostAppCallStackT_ests: XCTestCase {
  func testIsAbleToDetectT_est() {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackT_ests.self)
    )
  }

  func testIsAbleToDetectT_estAsync() async {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackT_ests.self)
    )
  }
}
