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

      func test_withKnownIssue_reportIssue() {
        _withKnownIssue {
          reportIssue()
        }
      }

      func test_withKnownIssue_issueRecord() {
        _withKnownIssue {
          XCTFail()
        }
      }

      func test_withKnownIssue_throw() {
        _withKnownIssue { throw Failure() }
      }

      func test_withKnownIssue_IsIntermittent() async throws {
        _withKnownIssue(isIntermittent: true) {
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

    func test_withKnownIssueNoIssueDoesNotFail() {
      _withKnownIssue {}
    }
  }
#endif

private struct Failure: Error {}
