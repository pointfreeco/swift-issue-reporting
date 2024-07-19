import IssueReporting
import XCTest

#if DEBUG
  class XCTestTests_Debug: XCTestCase {
    func testContext() {
      XCTAssertEqual(TestContext.current, .xcTest)
    }

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
  }
#else
  // class XCTestTests_Release: XCTestCase {
  //   func testContext() {
  //     XCTAssertEqual(TestContext.current, .xcTest)
  //   }
  //
  //   func testReportIssueDoesNotFail() {
  //     reportIssue()
  //   }
  //
  //   func testWithExpectedIssueNoIssueDoesNotFail() {
  //     withExpectedIssue {}
  //   }
  // }
#endif

private struct Failure: Error {}
