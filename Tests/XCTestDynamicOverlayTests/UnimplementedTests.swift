#if !os(Linux) && !os(WASI) && !os(Windows)
  import XCTest
  import XCTestDynamicOverlay

  final class UnimplementedTests: XCTestCase {
    func testXCTFailShouldFail() async throws {
      _ = XCTExpectFailure {
        f00()
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f00 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:98
          """
      }

      _ = XCTExpectFailure {
        f01("")
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f01 …

            Defined at:
              XCTestDynamicOverlayTests/TestHelpers.swift:99

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
              XCTestDynamicOverlayTests/TestHelpers.swift:100

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
              XCTestDynamicOverlayTests/TestHelpers.swift:101

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
              XCTestDynamicOverlayTests/TestHelpers.swift:102

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
              XCTestDynamicOverlayTests/TestHelpers.swift:103

            Invoked with:
              (
                "",
                42,
                1.2,
                [1, 2],
                XCTestDynamicOverlayTests.User(id: DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF)
              )
          """
      }

      _ = XCTExpectFailure {
        f01_multiline(MultilinePrintingType(someString: "hello", someInt: 10))
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f01_multiline …

            Defined at:
              XCTestDynamicOverlayTests/UnimplementedTests.swift:158

            Invoked with:
              MultilinePrintingType(
                someString: hello,
                someInt: 10
              )
          """
      }

      _ = XCTExpectFailure {
        f02_multiline(
          MultilinePrintingType(someString: "hello", someInt: 10),
          MultilinePrintingType(someString: "goodbye", someInt: 5)
        )
      } issueMatcher: {
        $0.compactDescription == """
          Unimplemented: f02_multiline …

            Defined at:
              XCTestDynamicOverlayTests/UnimplementedTests.swift:160

            Invoked with:
              (
                MultilinePrintingType(
                  someString: hello,
                  someInt: 10
                ),
                MultilinePrintingType(
                  someString: goodbye,
                  someInt: 5
                )
              )
          """
      }
    }
  }

  struct MultilinePrintingType {
    let someString: String
    let someInt: Int
  }

  extension MultilinePrintingType: CustomStringConvertible {
    var description: String {
      """
      MultilinePrintingType(
        someString: \(someString),
        someInt: \(someInt)
      )
      """
    }
  }

  let f01_multiline: (MultilinePrintingType) -> Int =
    unimplemented("f01_multiline", placeholder: 42)
  let f02_multiline: (MultilinePrintingType, MultilinePrintingType) -> Int =
    unimplemented("f02_multiline", placeholder: 42)
#endif
