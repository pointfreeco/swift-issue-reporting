import XCTest

final class XCTestDynamicOverlayTests: XCTestCase {
  func testXCTFail() async throws {
    MyXCTFail("This is expected to fail!")
  }
}
