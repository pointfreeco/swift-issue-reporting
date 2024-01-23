#if DEBUG && !os(Linux) && !os(Windows)
  import Foundation
  import XCTest
  import XCTestDynamicOverlay

  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif

  final class GeneratePlaceholderTests: XCTestCase {
    func testShouldGeneratePlaceholder() async throws {
      let bool: () -> Bool = unimplemented("bool")
      XCTAssertEqual(XCTExpectFailure(failingBlock: bool), false)
      let double: () -> Double = unimplemented("double")
      XCTAssertEqual(XCTExpectFailure(failingBlock: double), 0.0)
      let int: () -> Int = unimplemented("int")
      XCTAssertEqual(XCTExpectFailure(failingBlock: int), 0)
      let string: () -> String = unimplemented("string")
      XCTAssertEqual(XCTExpectFailure(failingBlock: string), "")

      let array: () -> [Int] = unimplemented("array")
      XCTAssertEqual(XCTExpectFailure(failingBlock: array), [Int]())
      let dictionary: () -> [String: Int] = unimplemented("dictionary")
      XCTAssertEqual(XCTExpectFailure(failingBlock: dictionary), [String: Int]())
      let set: () -> Set<Int> = unimplemented("set")
      XCTAssertEqual(XCTExpectFailure(failingBlock: set), Set<Int>())

      let optionalInt: () -> Int? = unimplemented("optionalInt")
      XCTAssertNil(XCTExpectFailure(failingBlock: optionalInt))

      let stream: () -> AsyncStream<Int> = unimplemented("stream")
      for await _ in XCTExpectFailure(failingBlock: stream) {
        XCTFail("Stream should be finished")
      }

      let throwingStream: () -> AsyncThrowingStream<Int, Error> = unimplemented("throwingStream")
      let result = await Task {
        try await XCTExpectFailure(failingBlock: throwingStream).first(where: { _ in true })
      }.result
      XCTAssertThrowsError(try result.get()) { XCTAssertTrue($0 is CancellationError) }

      let date: () -> Date = unimplemented("date")
      XCTAssertNotNil(XCTExpectFailure(failingBlock: date))
      let url: () -> URL = unimplemented("url")
      XCTAssertNotNil(XCTExpectFailure(failingBlock: url))
      let uuid: () -> UUID = unimplemented("uuid")
      XCTAssertNotNil(XCTExpectFailure(failingBlock: uuid))

      let enumCaseIterable: () -> EnumCaseIterable = unimplemented("enumCaseIterable")
      XCTAssertEqual(XCTExpectFailure(failingBlock: enumCaseIterable), .first)
      let enumInt: () -> EnumInt = unimplemented("enumInt")
      XCTAssertEqual(XCTExpectFailure(failingBlock: enumInt), .zero)
      let taggedInt: () -> Tagged<Self, Int> = unimplemented("taggedInt")
      XCTAssertEqual(XCTExpectFailure(failingBlock: taggedInt), 0)
    }
  }

  enum EnumInt: Int { case zero, one, two }

  enum EnumCaseIterable: CaseIterable { case first, second, third }

  struct Tagged<Tag, RawValue: Equatable>: Equatable { var rawValue: RawValue }
  extension Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = RawValue.IntegerLiteralType
    init(integerLiteral value: IntegerLiteralType) {
      self.init(rawValue: RawValue(integerLiteral: value))
    }
  }
#endif
