// NB: A dynamic version of 'Testing.withKnownIssue'
@_transparent
public func _withKnownIssue(
  _ message: String? = nil,
  isIntermittent: Bool = false,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column,
  _ body: () throws -> Void
) {
  guard let context = TestContext.current else {
    guard !isTesting else { return }
    let observer = FailureObserver()
    FailureObserver.$current.withValue(observer) {
      do {
        try body()
        if observer.withLock({ $0 == 0 }), !isIntermittent {
          for reporter in IssueReporters.current {
            reporter.reportIssue(
              "Known issue was not recorded\(message.map { ": \($0)" } ?? "")",
              fileID: IssueContext.current?.fileID ?? fileID,
              filePath: IssueContext.current?.filePath ?? filePath,
              line: IssueContext.current?.line ?? line,
              column: IssueContext.current?.column ?? column
            )
          }
        }
      } catch {
        for reporter in IssueReporters.current {
          reporter.expectIssue(
            error,
            message,
            fileID: IssueContext.current?.fileID ?? fileID,
            filePath: IssueContext.current?.filePath ?? filePath,
            line: IssueContext.current?.line ?? line,
            column: IssueContext.current?.column ?? column
          )
        }
      }
    }
    return
  }

  switch context {
  case .swiftTesting:
    _withKnownIssue(
      message,
      isIntermittent: isIntermittent,
      fileID: fileID.description,
      filePath: filePath.description,
      line: Int(line),
      column: Int(column),
      body
    )
  case .xcTest:
    _XCTExpectFailure(
      message.withAppHostWarningIfNeeded(),
      strict: !isIntermittent,
      file: filePath,
      line: line
    ) {
      do {
        try body()
      } catch {
        reportIssue(error, fileID: fileID, filePath: filePath, line: line, column: column)
      }
    }
  @unknown default: break
  }
}

#if compiler(>=6.0.2)
  // NB: A dynamic version of 'Testing.withKnownIssue'
  @_transparent
  public func _withKnownIssue(
    _ message: String? = nil,
    isIntermittent: Bool = false,
    isolation: isolated (any Actor)? = #isolation,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    _ body: _AsyncThrowingBody
  ) async {
    guard let context = TestContext.current else {
      guard !isTesting else { return }
      let observer = FailureObserver()
      await FailureObserver.$current.withValue(observer) {
        do {
          try await body()
          if observer.withLock({ $0 == 0 }), !isIntermittent {
            for reporter in IssueReporters.current {
              reporter.reportIssue(
                "Known issue was not recorded\(message.map { ": \($0)" } ?? "")",
                fileID: IssueContext.current?.fileID ?? fileID,
                filePath: IssueContext.current?.filePath ?? filePath,
                line: IssueContext.current?.line ?? line,
                column: IssueContext.current?.column ?? column
              )
            }
          }
        } catch {
          for reporter in IssueReporters.current {
            reporter.expectIssue(
              error,
              message,
              fileID: IssueContext.current?.fileID ?? fileID,
              filePath: IssueContext.current?.filePath ?? filePath,
              line: IssueContext.current?.line ?? line,
              column: IssueContext.current?.column ?? column
            )
          }
        }
      }
      return
    }

    switch context {
    case .swiftTesting:
      await _withKnownIssue(
        message,
        isIntermittent: isIntermittent,
        isolation: isolation,
        fileID: fileID.description,
        filePath: filePath.description,
        line: Int(line),
        column: Int(column),
        body
      )
    case .xcTest:
      reportIssue(
        """
        Asynchronously expecting failures is unavailable in XCTest.

        Omit this test from your XCTest suite, or consider using Swift Testing, instead.
        """,
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
      try? await body()
    @unknown default: break
    }
  }
#else
  @_transparent
  public func _withKnownIssue(
    _ message: String? = nil,
    isIntermittent: Bool = false,
    fileID: StaticString = #fileID,
    filePath: StaticString = #filePath,
    line: UInt = #line,
    column: UInt = #column,
    _ body: _AsyncThrowingBody
  ) async {
    guard let context = TestContext.current else {
      guard !isTesting else { return }
      let observer = FailureObserver()
      await FailureObserver.$current.withValue(observer) {
        do {
          try await body()
          if observer.withLock({ $0 == 0 }), !isIntermittent {
            for reporter in IssueReporters.current {
              reporter.reportIssue(
                "Known issue was not recorded\(message.map { ": \($0)" } ?? "")",
                fileID: IssueContext.current?.fileID ?? fileID,
                filePath: IssueContext.current?.filePath ?? filePath,
                line: IssueContext.current?.line ?? line,
                column: IssueContext.current?.column ?? column
              )
            }
          }
        } catch {
          for reporter in IssueReporters.current {
            reporter.expectIssue(
              error,
              message,
              fileID: IssueContext.current?.fileID ?? fileID,
              filePath: IssueContext.current?.filePath ?? filePath,
              line: IssueContext.current?.line ?? line,
              column: IssueContext.current?.column ?? column
            )
          }
        }
      }
      return
    }

    switch context {
    case .swiftTesting:
      await _withKnownIssue(
        message,
        isIntermittent: isIntermittent,
        fileID: fileID.description,
        filePath: filePath.description,
        line: Int(line),
        column: Int(column),
        body
      )
    case .xcTest:
      reportIssue(
        """
        Asynchronously expecting failures is unavailable in XCTest.

        Omit this test from your XCTest suite, or consider using Swift Testing, instead.
        """,
        fileID: fileID,
        filePath: filePath,
        line: line,
        column: column
      )
      try? await body()
    @unknown default: break
    }
  }
#endif
