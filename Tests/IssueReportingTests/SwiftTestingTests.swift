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
        issue.description == "Issue recorded"
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
        issue.description == "Issue recorded: Something went wrong"
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

    @Test func withExpectedIssue_reportIssue_Async() async {
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

    @Test func withExpectedIssue_NoMessage_NoIssue_Async() async {
      await withKnownIssue {
        await withExpectedIssue {
          await Task.yield()
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

    @Test func withExpectedIssue_CustomMessage_NoIssue_Async() async {
      await withKnownIssue {
        await withExpectedIssue("This didn't fail") {
          await Task.yield()
        }
      } matching: { issue in
        issue.description == "Known issue was not recorded: This didn't fail"
      }
    }

    @Test func withExpectedIssue_IsIntermittent() {
      withExpectedIssue(isIntermittent: true) {
      }
    }

    @Test func withExpectedIssue_IsIntermittent_Async() async {
      await withExpectedIssue(isIntermittent: true) {
        await Task.yield()
      }
    }
  }

  private struct Failure: Error {}
#endif
