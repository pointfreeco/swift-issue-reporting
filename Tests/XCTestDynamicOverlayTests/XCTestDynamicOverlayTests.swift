import XCTest

final class XCTestDynamicOverlayTests: XCTestCase {
  func testXCTFail() {
    MyXCTFail("This is expected to fail!")
  }
}
