import IssueReporting
import Testing
import Examples

extension ExampleTrait: @retroactive SuiteTrait, @retroactive TestTrait {
}

@Suite
struct TraitTests {
  @Test(ExampleTrait()) func hasTrait() {
    #expect(ExampleTrait.hasTrait())
  }

  @Test func doesNotHaveTrait() {
    #expect(ExampleTrait.hasTrait() == false)
  }
}
