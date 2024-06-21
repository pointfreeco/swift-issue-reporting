import TestingDynamicOverlay
import XCTest

struct Failure: Error {}

final class ExampleTests: XCTestCase {
  func testExample() {
    print(isTesting)

    XCTAssertEqual(TestContext.current, .xcTest)

    fail()
    fail("!")
    withKnownFailure {
      fail()
    }
    withKnownFailure {
      fail("This failed")
    }
    withKnownFailure {
    }
    withKnownFailure("This didn't fail") {
    }
    withKnownFailure(isIntermittent: true) {
    }
    withKnownFailure {} when: { false }
    withKnownFailure { throw Failure() }
    withKnownFailure { throw Failure() } when: { false }
  }
}

#if canImport(Testing)
  import Testing

  @Test func example() async throws {
    #expect(TestContext.current == .swiftTesting)

    fail()
    fail("!")
    withKnownFailure {
      fail()
    }
    withKnownFailure {
      fail("This failed")
    }
    withKnownFailure {
    }
    withKnownFailure("This didn't fail") {
    }
    withKnownFailure(isIntermittent: true) {
    }
    withKnownFailure {} when: { false }
    withKnownFailure { throw Failure() }
    withKnownFailure { throw Failure() } when: { false }
  }
#endif
