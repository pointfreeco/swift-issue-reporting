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
          issue.description.hasPrefix("Issue recorded")
        }
      }

      @Test func reportIssue_CustomMessage() {
        withKnownIssue {
          reportIssue("Something went wrong")
        } matching: { issue in
          issue.description.hasSuffix("Something went wrong")
        }
      }

      @Test func reportError_NoMessage() {
        struct Oops: Error {}
        withKnownIssue {
          reportIssue(Oops())
        }
      }

      #if compiler(>=6.2)
        @Test func reportIssue_CustomSeverity() {
          withKnownIssue {
            reportIssue("Something went less wrong", severity: .warning)
          } matching: { issue in
            issue.description.hasSuffix("Something went less wrong")
          }
        }
      #endif

      @Test func _withKnownIssue_reportIssue() {
        _withKnownIssue {
          reportIssue()
        }
      }

      @Test func _withKnownIssue_issueRecord() {
        _withKnownIssue {
          Issue.record()
        }
      }

      @Test func _withKnownIssue_throw() {
        _withKnownIssue { throw Failure() }
      }

      @Test func _withKnownIssue_NoMessage_NoIssue() {
        withKnownIssue {
          _withKnownIssue {
          }
        } matching: { issue in
          issue.description.hasPrefix("Known issue was not recorded")
        }
      }

      @Test func _withKnownIssue_CustomMessage_NoIssue() {
        withKnownIssue {
          _withKnownIssue("This didn't fail") {
          }
        } matching: { issue in
          issue.description.hasSuffix("This didn't fail")
        }
      }

      @Test func _withKnownIssue_IsIntermittent() async throws {
        _withKnownIssue(isIntermittent: true) {
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

      @Test func _withKnownIssueDoesNotFail() {
        _withKnownIssue {}
      }

      @Test func _withKnownIssueDoesNotFailAsync() async {
        await _withKnownIssue {
          await Task.yield()
        }
      }
    }
  #endif
#endif

private struct Failure: Error {}
