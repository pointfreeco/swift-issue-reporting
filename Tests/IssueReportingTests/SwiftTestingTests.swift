#if canImport(Testing) && !os(Windows)
  import Foundation
  import Testing
  import IssueReporting
  import Synchronization

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

    @Test func reportIssue_CustomMessage_WarningSeverity() {
      withIssueReporters([]) {
        reportIssue("Something went wrong", severity: .warning)
      }
    }

    @Test func reportError_CustomMessage() {
      withKnownIssue {
        reportIssue(Failure(), "Something went wrong")
      } matching: { issue in
        issue.description
          == "Caught error: Failure()\(issueDescriptionSuffix): Something went wrong"
      }
    }

    @available(iOS 18, macOS 15, watchOS 11, tvOS 18, *)
    @Test func severityIsForwardedToReporter() {
      let reporter = SeverityReporter()
      withIssueReporters([reporter]) {
        reportIssue("Something went wrong", severity: .warning)
      }
      #expect(reporter.severity.withLock { $0 } == .warning)
    }

    @Test func _withKnownIssue_reportIssue() {
      _withKnownIssue {
        reportIssue()
      }
    }

    @Test func _withKnownIssue_reportIssue_Async() async {
      await _withKnownIssue {
        await Task.yield()
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
        issue.description == "Known issue was not recorded\(issueDescriptionSuffix)"
      }
    }

    @Test func _withKnownIssue_NoMessage_NoIssue_Async() async {
      await withKnownIssue {
        await _withKnownIssue {
          await Task.yield()
        }
      } matching: { issue in
        issue.description == "Known issue was not recorded\(issueDescriptionSuffix)"
      }
    }

    @Test func _withKnownIssue_CustomMessage_NoIssue() {
      withKnownIssue {
        _withKnownIssue("This didn't fail") {
        }
      } matching: { issue in
        issue.description
          == "Known issue was not recorded\(issueDescriptionSuffix): This didn't fail"
      }
    }

    @Test func _withKnownIssue_CustomMessage_NoIssue_Async() async {
      await withKnownIssue {
        await _withKnownIssue("This didn't fail") {
          await Task.yield()
        }
      } matching: { issue in
        issue.description
          == "Known issue was not recorded\(issueDescriptionSuffix): This didn't fail"
      }
    }

    @Test func _withKnownIssue_IsIntermittent() {
      _withKnownIssue(isIntermittent: true) {
      }
    }

    @Test func _withKnownIssue_IsIntermittent_Async() async {
      await _withKnownIssue(isIntermittent: true) {
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

    @Test
    func emptyReporters() async throws {
      withIssueReporters([]) {
        reportIssue("This should not fail")
      }
    }
  }

  private struct Failure: Error {}

  @available(iOS 18, macOS 15, watchOS 11, tvOS 18, *)
  private final class SeverityReporter: IssueReporter {
    let severity = Mutex<IssueSeverity?>(nil)

    func reportIssue(
      _ message: @autoclosure () -> String?,
      severity: IssueSeverity,
      fileID: StaticString,
      filePath: StaticString,
      line: UInt,
      column: UInt
    ) {
      self.severity.withLock { $0 = severity }
    }
  }
#endif
