import TestingDynamicOverlay
import XCTest

struct Failure: Error {}

final class ExampleTests: XCTestCase {
  func testExample() {
    print(isTesting)

    XCTAssertEqual(TestContext.current, .xcTest)

    reportIssue()
    reportIssue("!")
    withExpectedIssue {
      reportIssue()
    }
    withExpectedIssue {
      reportIssue("This failed")
    }
    withExpectedIssue {
    }
    withExpectedIssue("This didn't fail") {
    }
    withExpectedIssue(isIntermittent: true) {
    }
    withExpectedIssue { throw Failure() }
  }
}

#if canImport(Testing)
  import Testing

  @Test func issueReporting() async throws {
    #expect(TestContext.current == .swiftTesting)

    reportIssue()
    reportIssue("!")
    withExpectedIssue {
      reportIssue()
    }
    withExpectedIssue {
      reportIssue("This failed")
    }
    withExpectedIssue {
    }
    withExpectedIssue("This didn't fail") {
    }
    withExpectedIssue(isIntermittent: true) {
    }
    withExpectedIssue { throw Failure() }
  }

  @Test func issueRecording() async throws {
    Issue.record()
    Issue.record("!")
    withKnownIssue {
      Issue.record()
    }
    withKnownIssue {
      Issue.record("This failed")
    }
    withKnownIssue {
    }
    withKnownIssue("This didn't fail") {
    }
    withKnownIssue(isIntermittent: true) {
    }
    withKnownIssue { throw Failure() }
  }
#endif
