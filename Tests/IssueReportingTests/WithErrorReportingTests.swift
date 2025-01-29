#if canImport(Testing)
  import Testing
  import IssueReporting

  @Suite
  struct WithErrorReportingTests {
    @Test func basics() {
      withKnownIssue {
        withErrorReporting {
          throw SomeError()
        }
      } matching: { issue in
        issue.description == "Caught error: SomeError()"
      }

      withKnownIssue {
        withErrorReporting("Failed") {
          throw SomeError()
        }
      } matching: { issue in
        issue.description == "Caught error: SomeError(): Failed"
      }
    }
  }

  private struct SomeError: Error {}
#endif
