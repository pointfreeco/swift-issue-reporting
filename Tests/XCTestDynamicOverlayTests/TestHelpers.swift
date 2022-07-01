import XCTestDynamicOverlay

func MyXCTFail(_ message: String) {
  XCTFail(message)
}

struct Client {
  var p00: () -> Int
  var p01: () throws -> Int
  var p02: () async -> Int
  var p03: () async throws -> Int
  var p04: (Int) -> Int
  var p05: (Int) throws -> Int
  var p06: (Int) async -> Int
  var p07: (Int) async throws -> Int
  var p08: (Int, Int) -> Int
  var p09: (Int, Int) throws -> Int
  var p10: (Int, Int) async -> Int
  var p11: (Int, Int) async throws -> Int
  var p12: (Int, Int, Int) -> Int
  var p13: (Int, Int, Int) throws -> Int
  var p14: (Int, Int, Int) async -> Int
  var p15: (Int, Int, Int) async throws -> Int
  var p16: (Int, Int, Int, Int) -> Int
  var p17: (Int, Int, Int, Int) throws -> Int
  var p18: (Int, Int, Int, Int) async -> Int
  var p19: (Int, Int, Int, Int) async throws -> Int
  var p20: (Int, Int, Int, Int, Int) -> Int
  var p21: (Int, Int, Int, Int, Int) throws -> Int
  var p22: (Int, Int, Int, Int, Int) async -> Int
  var p23: (Int, Int, Int, Int, Int) async throws -> Int

  static var unimplemented: Self {
    Self(
      p00: XCTUnimplemented("\(Self.self).p00"),
      p01: XCTUnimplemented("\(Self.self).p01"),
      p02: XCTUnimplemented("\(Self.self).p02"),
      p03: XCTUnimplemented("\(Self.self).p03"),
      p04: XCTUnimplemented("\(Self.self).p04"),
      p05: XCTUnimplemented("\(Self.self).p05"),
      p06: XCTUnimplemented("\(Self.self).p06"),
      p07: XCTUnimplemented("\(Self.self).p07"),
      p08: XCTUnimplemented("\(Self.self).p08"),
      p09: XCTUnimplemented("\(Self.self).p09"),
      p10: XCTUnimplemented("\(Self.self).p10"),
      p11: XCTUnimplemented("\(Self.self).p11"),
      p12: XCTUnimplemented("\(Self.self).p12"),
      p13: XCTUnimplemented("\(Self.self).p13"),
      p14: XCTUnimplemented("\(Self.self).p14"),
      p15: XCTUnimplemented("\(Self.self).p15"),
      p16: XCTUnimplemented("\(Self.self).p16"),
      p17: XCTUnimplemented("\(Self.self).p17"),
      p18: XCTUnimplemented("\(Self.self).p18"),
      p19: XCTUnimplemented("\(Self.self).p19"),
      p20: XCTUnimplemented("\(Self.self).p20"),
      p21: XCTUnimplemented("\(Self.self).p21"),
      p22: XCTUnimplemented("\(Self.self).p22"),
      p23: XCTUnimplemented("\(Self.self).p23")
    )
  }
}
