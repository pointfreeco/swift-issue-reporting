import IssueReporting
import XCTest

struct Failure: Error {}

final class XCTestTests: XCTestCase {
  func testIsTesting() {
    XCTAssertTrue(isTesting)
  }

  func testTestContext() {
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
}
