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
    }
  }

  private struct SomeError: Error {}
#endif
