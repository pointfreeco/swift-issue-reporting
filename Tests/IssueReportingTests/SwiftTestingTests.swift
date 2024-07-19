#if canImport(Testing)
  import Testing
  import IssueReporting

  @Suite
  struct SwiftTestingTests {
    @Test func context() {
      #expect(TestContext.current == .swiftTesting)
    }

    @Test func reportIssue_NoMessage() {
      withKnownIssue {
        reportIssue()
      } matching: { issue in
        issue.description == "Expectation failed: "
      }
    }

    @Test func reportError_NoMessage() {
      struct MyError: Error {}
      withKnownIssue {
        reportIssue(Failure())
      } matching: { issue in
        issue.description == "Caught error: Failure()"
      }
    }

    @Test func reportIssue_CustomMessage() {
      withKnownIssue {
        reportIssue("Something went wrong")
      } matching: { issue in
        issue.description == "Expectation failed: Something went wrong"
      }
    }

    @Test func reportError_CustomMessage() {
      withKnownIssue {
        reportIssue(Failure(), "Something went wrong")
      } matching: { issue in
        issue.description == "Caught error: Failure(): Something went wrong"
      }
    }

    @Test func withExpectedIssue_reportIssue() {
      withExpectedIssue {
        reportIssue()
      }
    }

    @Test func withExpectedAsyncIssue_reportIssue() async {
      await withExpectedIssue {
        await Task.yield()
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

  private struct Failure: Error {}
#endif

