public func XCTImplemented<Parameters, Result>(
  _ description: @autoclosure @escaping @Sendable () -> String = "",
  expectedFulfillmentCount: Int = 1,
  assertForOverfulfill: Bool = false,
  _ body: @escaping @Sendable (Parameters) -> Result,
  file: StaticString = #file,
  line: UInt = #line
) -> @Sendable (Parameters) -> Result {

  let spy = Spy(
    assertForOverfulfill: assertForOverfulfill,
    description: description,
    expectedFulfillmentCount: expectedFulfillmentCount,
    file: file,
    line: line
  )
  return {
    spy.fulfillmentCount += 1
    return body($0)
  }
}

// TODO: Overloads

private final class Spy {
  let assertForOverfulfill: Bool
  let description: () -> String
  let expectedFulfillmentCount: Int
  let file: StaticString
  let line: UInt
  var fulfillmentCount = 0

  init(
    assertForOverfulfill: Bool,
    description: @escaping () -> String,
    expectedFulfillmentCount: Int,
    file: StaticString,
    line: UInt
  ) {
    self.assertForOverfulfill = assertForOverfulfill
    self.description = description
    self.expectedFulfillmentCount = expectedFulfillmentCount
    self.file = file
    self.line = line
  }

  deinit {
    if self.fulfillmentCount < self.expectedFulfillmentCount {
      let description = description()
      XCTFail(
        """
        """,
        file: self.file,
        line: self.line
      )
    } else if self.fulfillmentCount > self.expectedFulfillmentCount && self.assertForOverfulfill {
      let description = description()
      XCTFail(
        """
        """,
        file: self.file,
        line: self.line
      )
    }
  }
}
