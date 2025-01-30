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

    @Test func overload() async {
      await withKnownIssue {
        await withErrorReporting { () async throws in
          throw SomeError()
        }
      } matching: { issue in
        issue.description == "Caught error: SomeError()"
      }

      await withKnownIssue {
        await withErrorReporting("Failed") { () async throws in
          throw SomeError()
        }
      } matching: { issue in
        issue.description == "Caught error: SomeError(): Failed"
      }
    }
  }

  private struct SomeError: Error {}
#endif
