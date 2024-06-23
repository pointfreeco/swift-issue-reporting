//import TestingDynamicOverlay
//import XCTest
//
//struct Failure: Error {}
//
//final class ExampleTests: XCTestCase {
//  func testExample() {
//    print(isTesting)
//
//    XCTAssertEqual(TestContext.current, .xcTest)
//
//    reportIssue()
//    reportIssue("!")
//    withExpectedIssue {
//      reportIssue()
//    }
//    withExpectedIssue {
//      reportIssue("This failed")
//    }
//    withExpectedIssue {
//    }
//    withExpectedIssue("This didn't fail") {
//    }
//    withExpectedIssue(isIntermittent: true) {
//    }
//    withExpectedIssue {} when: { false }
//    withExpectedIssue { throw Failure() }
//    withExpectedIssue { throw Failure() } when: { false }
//  }
//}
//
//#if canImport(Testing)
//  import Testing
//
//  @Test func example() async throws {
//    #expect(TestContext.current == .swiftTesting)
//
//    reportIssue()
//    reportIssue("!")
//    withExpectedIssue {
//      reportIssue()
//    }
//    withExpectedIssue {
//      reportIssue("This failed")
//    }
//    withExpectedIssue {
//    }
//    withExpectedIssue("This didn't fail") {
//    }
//    withExpectedIssue(isIntermittent: true) {
//    }
//    withExpectedIssue {} when: { false }
//    withExpectedIssue { throw Failure() }
//    withExpectedIssue { throw Failure() } when: { false }
//  }
//#endif
