import IssueReporting
import XCTest

#if DEBUG
  class XCTestTests_Debug: XCTestCase {
    func testContext() {
      switch TestContext.current {
      case .xcTest:
        XCTAssert(true)
      default:
        XCTFail()
      }
    }

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

      func testWithExpectedIssue_reportIssue() {
        withExpectedIssue {
          reportIssue()
        }
      }

      func testWithExpectedIssue_issueRecord() {
        withExpectedIssue {
          XCTFail()
        }
      }

      func testWithExpectedIssue_throw() {
        withExpectedIssue { throw Failure() }
      }

      func testWithExpectedIssue_IsIntermittent() async throws {
        withExpectedIssue(isIntermittent: true) {
        }
      }
    #endif
  }
#else
  class XCTestTests_Release: XCTestCase {
    func testContext() {
      switch TestContext.current {
      case .xcTest:
        XCTAssert(true)
      default:
        XCTFail()
      }
    }

    func testReportIssueDoesNotFail() {
      reportIssue()
    }

    func testWithExpectedIssueNoIssueDoesNotFail() {
      withExpectedIssue {}
    }
  }
#endif

private struct Failure: Error {}
