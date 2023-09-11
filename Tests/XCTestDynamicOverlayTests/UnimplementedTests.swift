// TODO: https://github.com/apple/swift-corelibs-xctest/issues/438
#if !os(Linux) && !os(Windows)
  import XCTest

  final class UnimplementedTests: XCTestCase {
    func testXCTFailShouldFail() async throws {
      _ = XCTExpectFailure {
        f00()
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f00 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:66
          """
      }

      _ = XCTExpectFailure {
        f01("")
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f01 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:67

            Invoked with:
              ""
          """
      }

      _ = XCTExpectFailure {
        f02("", 42)
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f02 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:68

            Invoked with:
              ("", 42)
          """
      }

      _ = XCTExpectFailure {
        f03("", 42, 1.2)
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f03 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:69

            Invoked with:
              ("", 42, 1.2)
          """
      }

      _ = XCTExpectFailure {
        f04("", 42, 1.2, [1, 2])
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f04 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:70

            Invoked with:
              ("", 42, 1.2, [1, 2])
          """
      }

      _ = XCTExpectFailure {
        f05(
          "", 42, 1.2, [1, 2], User(id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!)
        )
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f05 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:71

            Invoked with:
              ("", 42, 1.2, [1, 2], XCTestDynamicOverlayTests.User(id: DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF))
          """
      }
    }
  }
#endif
