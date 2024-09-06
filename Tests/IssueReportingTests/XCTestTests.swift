import IssueReporting
import XCTest

final class XCTestTests: XCTestCase {
  #if !os(WASI)
    func testIsTesting() {
      XCTAssertTrue(isTesting)
    }

    func testTestContext() {
      switch TestContext.current {
      case .xcTest:
        XCTAssert(true)
      default:
        XCTFail()
      }
    }
  #endif

  #if _runtime(_ObjC)
    func testReportIssue_NoMessage() {
      XCTExpectFailure {
        reportIssue()
      } issueMatcher: {
        $0.compactDescription == "failed"
      }
    }

    func testReportIssue_CustomMessage() {
      XCTExpectFailure {
        reportIssue("Something went wrong")
      } issueMatcher: {
        $0.compactDescription == "failed - Something went wrong"
      }
    }

    func testWithExpectedIssue() {
      withExpectedIssue {
        reportIssue("Something went wrong")
      }
    }

    func testWithExpectedIssue_XCTFail() {
      withExpectedIssue {
        XCTFail()
      }
    }

    func testWithExpectedIssue_Throwing() {
      withExpectedIssue { throw Failure() }
    }
  #endif
}

private struct Failure: Error {}
