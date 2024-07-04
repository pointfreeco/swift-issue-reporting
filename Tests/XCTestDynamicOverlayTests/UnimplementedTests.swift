#if !os(Linux) && !os(WASI) && !os(Windows)
  import XCTest

  final class UnimplementedTests: XCTestCase {
    func testXCTFailShouldFail() async throws {
      _ = XCTExpectFailure {
        f00()
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f00 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:99:46

            Invoked from 'XCTestDynamicOverlayTests' with:
              ()
          """
      }

      _ = XCTExpectFailure {
        f01("")
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f01 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:100:52

            Invoked from 'XCTestDynamicOverlayTests' with:
              ""
          """
      }

      _ = XCTExpectFailure {
        f02("", 42)
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f02 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:101:57

            Invoked from 'XCTestDynamicOverlayTests' with:
              ("", 42)
          """
      }

      _ = XCTExpectFailure {
        f03("", 42, 1.2)
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f03 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:102:65

            Invoked from 'XCTestDynamicOverlayTests' with:
              ("", 42, 1.2)
          """
      }

      _ = XCTExpectFailure {
        f04("", 42, 1.2, [1, 2])
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f04 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:103:72

            Invoked from 'XCTestDynamicOverlayTests' with:
              ("", 42, 1.2, [1, 2])
          """
      }

      _ = XCTExpectFailure {
        f05(
          "", 42, 1.2, [1, 2], User(id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!)
        )
      } issueMatcher: {
        $0.compactDescription == """
          failed - Unimplemented: f05 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:104:78

            Invoked from 'XCTestDynamicOverlayTests' with:
              ("", 42, 1.2, [1, 2], XCTestDynamicOverlayTests.User(id: DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF))
          """
      }
    }
  }
#endif
