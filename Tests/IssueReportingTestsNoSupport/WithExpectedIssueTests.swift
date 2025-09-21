#if canImport(Testing)
  import IssueReporting
  import Testing

  @Suite struct WithExpectedIssueTests {
    @Test func sync() {
      withExpectedIssue {
        reportIssue()
      }
    }

    @Test func syncThrows() throws {
      withExpectedIssue {
        reportIssue()
        throw SomeError()
      }
    }

    @Test func asyncAwaitBefore() async {
      await withExpectedIssue {
        await Task.yield()
        reportIssue()
      }
    }

    @Test func asyncAwaitAfter() async {
      await withExpectedIssue {
        reportIssue()
        await Task.yield()
      }
    }

    @Test func asyncAwaitBeforeThrows() async throws {
      await withExpectedIssue {
        await Task.yield()
        reportIssue()
        throw SomeError()
      }
    }

    @Test func asyncAwaitAfterThrows() async throws {
      await withExpectedIssue {
        reportIssue()
        await Task.yield()
        throw SomeError()
      }
    }
  }

  private struct SomeError: Error {}
#endif
