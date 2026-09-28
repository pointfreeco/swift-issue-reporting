#if canImport(Testing) && !os(Windows)
  import IssueReporting
  import Testing

  struct ExpectReportsIssueTests {
    @Test func expectedIssue() {
      expectReportsIssue {
        reportIssue("Oops")
      } matching: {
        $0.description.contains("Oops")
      }
    }

    @Test func expectedAsyncIssue() async {
      await expectReportsIssue {
        await Task.yield()
        reportIssue("Oops")
      } matching: {
        $0.description.contains("Oops")
      }
    }

    @Test func unexpectedIssue() {
      expectReportsIssue {
        expectReportsIssue {
          reportIssue("Oops")
        } matching: { _ in
          false
        }
      } matching: {
        $0.description.contains(
          """
          Issue does not match: Issue reported: Oops
          """
        )
      }
    }

    @Test func unexpectedAsyncIssue() async {
      await expectReportsIssue {
        await Task.yield()
        expectReportsIssue {
          reportIssue("Oops")
        } matching: { _ in
          false
        }
      } matching: {
        $0.description.contains(
          """
          Issue does not match: Issue reported: Oops
          """
        )
      }
    }

    @Test func expectedErrorIssue() {
      struct Failure: Error {}
      expectReportsIssue {
        reportIssue(Failure())
      } matching: {
        $0.error is Failure
      }
    }

    @Test func expectedAsyncErrorIssue() async {
      struct Failure: Error {}
      await expectReportsIssue {
        await Task.yield()
        reportIssue(Failure())
      } matching: {
        $0.error is Failure
      }
    }  }

#endif
