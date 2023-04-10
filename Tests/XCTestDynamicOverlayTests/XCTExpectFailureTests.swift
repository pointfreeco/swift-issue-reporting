import XCTest

final class XCTExpectFailureTests: XCTestCase {
  func testXCTDynamicOverlayShouldFail() async throws {
    MyXCTExpectFailure(strict: false, message: "This is expected to pass.") {
      XCTAssertEqual(42, 42)
    }

    MyXCTExpectFailure(strict: true, message: "This is expected to pass.") {
      XCTAssertEqual(42, 1729)
    }

    if ProcessInfo.processInfo.environment["TEST_FAILURE"] != nil {
      MyXCTExpectFailure(strict: true, message: "This is expected to fail!") {
        XCTAssertEqual(42, 42)
      }
    }
  }
}
