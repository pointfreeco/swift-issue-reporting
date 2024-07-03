#if canImport(Testing)
import Testing
import IssueReporting

@Suite
struct IssueReporting_SwiftTesting {
  @Test func testContext() {
    #expect(TestContext.current == .swiftTesting)
  }

  @Test func reportIssue_NoMessage() {
    withKnownIssue {
      reportIssue()
    } matching: { issue in
      issue.description == "Expectation failed: "
    }
  }

  @Test func reportIssue_CustomMessage() {
    withKnownIssue {
      reportIssue("Something went wrong")
    } matching: { issue in
      issue.description == "Expectation failed: Something went wrong"
    }
  }

  @Test func withExpectedIssue_reportIssue() {
    withExpectedIssue {
      reportIssue()
    }
  }

  @Test func withExpectedIssue_issueRecord() {
    withExpectedIssue {
      Issue.record()
    }
  }

  @Test func withExpectedIssue_throw() {
    withExpectedIssue { throw Failure() }
  }

  @Test func withExpectedIssue_NoMessage_NoIssue() {
    withKnownIssue {
      withExpectedIssue {
      }
    } matching: { issue in
      issue.description == "Known issue was not recorded"
    }
  }

  @Test func withExpectedIssue_CustomMessage_NoIssue() {
    withKnownIssue {
      withExpectedIssue("This didn't fail") {
      }
    } matching: { issue in
      issue.description == "Known issue was not recorded: This didn't fail"
    }
  }

  @Test func withExpectedIssue_IsIntermittent() async throws {
    withExpectedIssue(isIntermittent: true) {
    }
  }
}
#endif
