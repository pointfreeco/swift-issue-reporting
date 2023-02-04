import XCTest
@testable import XCTestDynamicOverlay

final class HostAppCallStackTests: XCTestCase {
  func testIsAbleToDetectTest() {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackTests.self)
    )
  }

  func testIsAbleToDetectAsyncTest() async {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackTests.self)
    )
  }
  
  func testIsAbleToDetectThrowingTest() throws {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackTests.self)
    )
  }
  
  func testIsAbleToDetectAsyncThrowingTest() async throws {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackTests.self)
    )
  }
  
  #if !os(Linux)
  func testFailDoesNotAppendHostAppWarningFromATest() {
    XCTExpectFailure {
      XCTestDynamicOverlay.XCTFail("foo")
    } issueMatcher: {
      $0.compactDescription == "foo"
    }
  }
  #endif
}
