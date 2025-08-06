#if canImport(Testing) && !os(Windows)
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
        issue.description == "Caught error: SomeError()\(issueDescriptionSuffix)"
      }

      withKnownIssue {
        withErrorReporting("Failed") {
          throw SomeError()
        }
      } matching: { issue in
        issue.description == "Caught error: SomeError()\(issueDescriptionSuffix): Failed"
      }
    }

    @Test func overload() async {
      await withKnownIssue {
        await withErrorReporting { () async throws in
          throw SomeError()
        }
      } matching: { issue in
        issue.description == "Caught error: SomeError()\(issueDescriptionSuffix)"
      }

      await withKnownIssue {
        await withErrorReporting("Failed") { () async throws in
          throw SomeError()
        }
      } matching: { issue in
        issue.description == "Caught error: SomeError()\(issueDescriptionSuffix): Failed"
      }
    }

    #if compiler(<6.2)
      @MainActor
      @Test func isolation() async {
        await withKnownIssue {
          await withErrorReporting { () async throws in
            throw SomeError()
          }
        } matching: { issue in
          issue.description == "Caught error: SomeError()"
        }
      }
    #endif
  }

  private struct SomeError: Error {}
#endif
