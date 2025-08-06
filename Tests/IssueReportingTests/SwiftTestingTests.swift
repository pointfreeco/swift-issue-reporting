#if canImport(Testing) && !os(Windows)
  import Testing
  import IssueReporting

  @Suite
  struct SwiftTestingTests {
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
        issue.description == "Issue recorded\(issueDescriptionSuffix)"
      }
    }

    @Test func reportError_NoMessage() {
      struct MyError: Error {}
      withKnownIssue {
        reportIssue(Failure())
      } matching: { issue in
        issue.description == "Caught error: Failure()\(issueDescriptionSuffix)"
      }
    }

    @Test func reportIssue_CustomMessage() {
      withKnownIssue {
        reportIssue("Something went wrong")
      } matching: { issue in
        issue.description == "Issue recorded\(issueDescriptionSuffix): Something went wrong"
      }
    }

    @Test func reportError_CustomMessage() {
      withKnownIssue {
        reportIssue(Failure(), "Something went wrong")
      } matching: { issue in
        issue.description == "Caught error: Failure()\(issueDescriptionSuffix): Something went wrong"
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
        issue.description == "Known issue was not recorded\(issueDescriptionSuffix)"
      }
    }

    @Test func withExpectedIssue_NoMessage_NoIssue_Async() async {
      await withKnownIssue {
        await withExpectedIssue {
          await Task.yield()
        }
      } matching: { issue in
        issue.description == "Known issue was not recorded\(issueDescriptionSuffix)"
      }
    }

    @Test func withExpectedIssue_CustomMessage_NoIssue() {
      withKnownIssue {
        withExpectedIssue("This didn't fail") {
        }
      } matching: { issue in
        issue.description == "Known issue was not recorded\(issueDescriptionSuffix): This didn't fail"
      }
    }

    @Test func withExpectedIssue_CustomMessage_NoIssue_Async() async {
      await withKnownIssue {
        await withExpectedIssue("This didn't fail") {
          await Task.yield()
        }
      } matching: { issue in
        issue.description == "Known issue was not recorded\(issueDescriptionSuffix): This didn't fail"
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

    @Test func overrideIssueContext() {
      withKnownIssue {
        withIssueContext(fileID: #fileID, filePath: #filePath, line: #line, column: #column) {
          reportIssue("Something went wrong")
        }
      } matching: { issue in
        let expectedReportingLine = #line - 4
        return issue.sourceLocation?.line == expectedReportingLine
          && issue.description == "Issue recorded\(issueDescriptionSuffix): Something went wrong"
      }
    }

    @Test
    func emptyMessage() {
      withKnownIssue {
        reportIssue("")
      }
    }

    @Test
    func emptyMessage_async() async {
      await withKnownIssue {
        await Task.yield()
        reportIssue("")
      }
    }

    @Test
    func emptyMessage_throws() throws {
      withKnownIssue {
        reportIssue("")
      }
    }

    @Test
    func emptyMessage_asyncThrows() async throws {
      await withKnownIssue {
        await Task.yield()
        reportIssue("")
      }
    }
  }

  private struct Failure: Error {}
#endif
