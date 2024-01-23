#if DEBUG && !os(Linux) && !os(Windows)
  import XCTest
  import XCTestDynamicOverlay

  public final class XCTContextTests: XCTestCase {
    func testContext() {
      XCTExpectFailure {
        $0.compactDescription == "Failed"
          && $0.sourceCodeContext.location
            == XCTSourceCodeLocation(filePath: "unknown", lineNumber: 1)
      }
      XCTFailContext.$current.withValue(XCTFailContext(file: "unknown", line: 1)) {
        XCTestDynamicOverlay.XCTFail("Failed")
      }
    }
  }
#endif
