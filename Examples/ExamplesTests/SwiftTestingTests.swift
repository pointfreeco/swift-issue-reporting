#if canImport(Testing)
  import IssueReporting
  import Testing

  #if DEBUG
    @Suite
    struct SwiftTestingTests_Debug {
      @Test func context() {
        switch TestContext.current {
        case .swiftTesting:
          #expect(Bool(true))
        default:
          Issue.record()
        }
      }

      @Test func reportIssue_NoMessage() {
        withKnownIssue {
          reportIssue()
        } matching: { issue in
          issue.description == "Issue recorded"
        }
      }

      @Test func reportIssue_CustomMessage() {
        withKnownIssue {
          reportIssue("Something went wrong")
        } matching: { issue in
          issue.description == "Issue recorded: Something went wrong"
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
  #else
    @Suite
    struct SwiftTestingTests_Release {
      @Test func context() {
        switch TestContext.current {
        case .xcTest:
          #expect(Bool(true))
        default:
          Issue.record()
        }
      }

      @Test func reportIssueDoesNotFail() {
        reportIssue()
      }

      @Test func withExpectedIssueDoesNotFail() {
        withExpectedIssue {}
      }

      @Test func withExpectedIssueDoesNotFailAsync() async {
        await withExpectedIssue {
          await Task.yield()
        }
      }
    }
  #endif
#endif

private struct Failure: Error {}
