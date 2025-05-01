import Examples
import IssueReporting
import Testing

extension ExampleTrait: @retroactive SuiteTrait, @retroactive TestTrait {
}

@Suite
struct TraitTests {
  @Test(ExampleTrait()) func hasTrait() {
    #if DEBUG
      #expect(ExampleTrait.hasTrait())
    #else
      #expect(ExampleTrait.hasTrait() == false)
    #endif
  }

  @Test func doesNotHaveTrait() {
    #expect(ExampleTrait.hasTrait() == false)
  }
}
