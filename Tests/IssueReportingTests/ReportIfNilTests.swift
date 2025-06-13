#if canImport(Testing) && !os(Windows)
import Testing
import IssueReporting

@Suite
struct ReportIfNilTests {

  @Test
  func reportsIssueForNilValueWithDefaultMessage() {
    withKnownIssue {
      _ = reportIfNil(Optional<String>.none)
    } matching: { issue in
      issue.error is NilValueError &&
      issue.description == "Caught error: NilValueError(): Unexpected nil value"
    }
  }

  @Test
  func reportsIssueForNilValueWithCustomMessage() {
    withKnownIssue {
      _ = reportIfNil(Optional<String>.none, message: "Custom nil message")
    } matching: { issue in
      issue.error is NilValueError &&
      issue.description == "Caught error: NilValueError(): Custom nil message"
    }
  }

  @Test
  func doesNotReportIssueForNonNilValue() {
    let value: String? = "non-nil"
    #expect(reportIfNil(value) == "non-nil")
  }
}

#endif
