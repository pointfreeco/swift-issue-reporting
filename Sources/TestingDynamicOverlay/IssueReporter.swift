/*
 @main
 …
 init() {
   if !isTesting {
     IssueReporting.defaultReports = [.runtimeWarn, …]
   }
 }
 */

public protocol IssueReporter {
  func reportIssue(_ message: String)
}

struct RuntimeWarningReporter: IssueReporter {
  func reportIssue(_ message: String) {
    guard !isTesting else { return }
    if let observer = FailureObserver.current {
      if observer.withLock({
        $0.count += 1
        return $0.precondition
      }) {
        runtimeNote(message, fileID: "TODO", line: 0 /*TODO*/)
      }
    } else {
      runtimeWarn(message, fileID: "TODO", line: 0 /*TODO*/)
    }
  }
}

struct BreakpointReporter: IssueReporter {
  func reportIssue(_ message: String) {
    // breakpoint
  }
}

struct FatalErrorReporter: IssueReporter {
  func reportIssue(_ message: String) {
    fatalError()
  }
}

// TODO: this should be empty array
struct NoopReporter: IssueReporter {
  func reportIssue(_ message: String) {}
}
