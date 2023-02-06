#if DEBUG && canImport(ObjectiveC)
  import XCTest

  @testable import XCTestDynamicOverlay

  final class HostAppCallStackTests: XCTestCase {
    func testIsAbleToDetectTest() {
      XCTAssert(Thread.callStackSymbols.contains(where: isTestFrame))
    }

    func testIsAbleToDetectAsyncTest() async {
      XCTAssert(Thread.callStackSymbols.contains(where: isTestFrame))
    }

    func testIsAbleToDetectThrowingTest() throws {
      XCTAssert(Thread.callStackSymbols.contains(where: isTestFrame))
    }

    func testIsAbleToDetectAsyncThrowingTest() async throws {
      XCTAssert(Thread.callStackSymbols.contains(where: isTestFrame))
    }
  }
#endif
