#if !os(Linux)
  import XCTest

  final class UnimplementedTests: XCTestCase {
    func testXCTFailShouldFail() async throws {
      _ = XCTExpectFailure {
        f00()
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f00 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:84
          """
      }

      _ = XCTExpectFailure {
        f01("")
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f01 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:85

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
              XCTestDynamicOverlayTests/TestHelpers.swift:86

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
              XCTestDynamicOverlayTests/TestHelpers.swift:87

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
              XCTestDynamicOverlayTests/TestHelpers.swift:88

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
              XCTestDynamicOverlayTests/TestHelpers.swift:89

            Invoked with:
              ("", 42, 1.2, [1, 2], XCTestDynamicOverlayTests.User(id: DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF))
          """
      }

      _ = XCTExpectFailure {
        f06(
          "", 42, 1.2, [1, 2], User(id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!), Domain(id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!)
        )
      } issueMatcher: {
        $0.compactDescription == """
        Unimplemented: f06 …

          Defined at:
            XCTestDynamicOverlayTests/TestHelpers.swift:90

          Invoked with:
            ("", 42, 1.2, [1, 2], XCTestDynamicOverlayTests.User(id: DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF), XCTestDynamicOverlayTests.Domain(id: DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF))
        """
      }

      _ = XCTExpectFailure {
        f07(
          "", 42, 1.2, [1, 2], User(id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!), Domain(id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!), Session(id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")!)
        )
      } issueMatcher: {
        $0.compactDescription == """
        Unimplemented: f07 …

          Defined at:
            XCTestDynamicOverlayTests/TestHelpers.swift:91

          Invoked with:
            ("", 42, 1.2, [1, 2], XCTestDynamicOverlayTests.User(id: DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF), XCTestDynamicOverlayTests.Domain(id: DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF), XCTestDynamicOverlayTests.Session(id: DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF))
        """
      }
    }
  }
#endif
