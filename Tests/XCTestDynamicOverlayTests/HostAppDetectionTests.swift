import XCTest
@testable import XCTestDynamicOverlay

final class HostAppCallStackTests: XCTestCase {
  func testIsAbleToDetectTest() {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackTests.self)
    )
  }

  func testIsAbleToDetectTestAsync() async {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackTests.self)
    )
  }
  
  func testIsAbleToDetectTestThrows() throws {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackTests.self)
    )
  }
  
  func testIsAbleToDetectTestAsyncThrows() async throws {
    XCTAssertEqual(
      testCaseSubclass(callStackSymbols: Thread.callStackSymbols).map(ObjectIdentifier.init),
      ObjectIdentifier(HostAppCallStackTests.self)
    )
  }
}
