import XCTest

final class XCTestDynamicOverlayTests: XCTestCase {
    
    func testXCTFail() {
        XCTExpectFailure("Verify that we can fail.") {
            MyXCTFail("This is expected to fail!")
        }
    }
    
}
