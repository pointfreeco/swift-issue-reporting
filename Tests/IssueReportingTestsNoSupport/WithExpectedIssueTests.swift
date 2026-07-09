#if canImport(Testing)
  import IssueReporting
  import Testing

  @Suite struct WithKnownIssueTests {
    @Test func sync() {
      _withKnownIssue {
        reportIssue("Oops!")
      }
    }

    @Test func syncThrows() throws {
      _withKnownIssue {
        reportIssue("Oops!")
        throw SomeError()
      }
    }

    @Test func asyncAwaitBefore() async {
      await _withKnownIssue {
        await Task.yield()
        reportIssue("Oops!")
      }
    }

    @Test func asyncAwaitAfter() async {
      await _withKnownIssue {
        reportIssue("Oops!")
        await Task.yield()
      }
    }

    @Test func asyncAwaitBeforeThrows() async throws {
      await _withKnownIssue {
        await Task.yield()
        reportIssue("Oops!")
        throw SomeError()
      }
    }

    @Test func asyncAwaitAfterThrows() async throws {
      await _withKnownIssue {
        reportIssue("Oops!")
        await Task.yield()
        throw SomeError()
      }
    }
  }

  private struct SomeError: Error {}
#endif
