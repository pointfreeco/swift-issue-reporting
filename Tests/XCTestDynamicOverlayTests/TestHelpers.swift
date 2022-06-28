import XCTestDynamicOverlay

func MyXCTFail(_ message: String) {
  XCTFail(message)
}

struct Client {
  var p00: () -> Void
  var p01: () -> Int
  var p02: () throws -> Int
  var p03: () async -> Void
  var p04: () async -> Int
  var p05: () async throws -> Int
  var p06: (Int) -> Void
  var p07: (Int) -> Int
  var p08: (Int) throws -> Int
  var p09: (Int) async -> Void
  var p10: (Int) async -> Int
  var p11: (Int) async throws -> Int
  var p12: (Int, Int) -> Void
  var p13: (Int, Int) -> Int
  var p14: (Int, Int) throws -> Int
  var p15: (Int, Int) async -> Void
  var p16: (Int, Int) async -> Int
  var p17: (Int, Int) async throws -> Int
  var p18: (Int, Int, Int) -> Void
  var p19: (Int, Int, Int) -> Int
  var p20: (Int, Int, Int) throws -> Int
  var p21: (Int, Int, Int) async -> Void
  var p22: (Int, Int, Int) async -> Int
  var p23: (Int, Int, Int) async throws -> Int
  var p24: (Int, Int, Int, Int) -> Void
  var p25: (Int, Int, Int, Int) -> Int
  var p26: (Int, Int, Int, Int) throws -> Int
  var p27: (Int, Int, Int, Int) async -> Void
  var p28: (Int, Int, Int, Int) async -> Int
  var p29: (Int, Int, Int, Int) async throws -> Int
  var p30: (Int, Int, Int, Int, Int) -> Void
  var p31: (Int, Int, Int, Int, Int) -> Int
  var p32: (Int, Int, Int, Int, Int) throws -> Int
  var p33: (Int, Int, Int, Int, Int) async -> Void
  var p34: (Int, Int, Int, Int, Int) async -> Int
  var p35: (Int, Int, Int, Int, Int) async throws -> Int

  static var unimplementedA: Self {
    Self(
      p00: XCTUnimplemented("\(Self.self).p00"),
      p01: XCTUnimplemented("\(Self.self).p01", placeholder: 42),
      p02: XCTUnimplemented("\(Self.self).p02"),
      p03: XCTUnimplemented("\(Self.self).p03"),
      p04: XCTUnimplemented("\(Self.self).p04", placeholder: 42),
      p05: XCTUnimplemented("\(Self.self).p05"),
      p06: XCTUnimplemented("\(Self.self).p06"),
      p07: XCTUnimplemented("\(Self.self).p07", placeholder: 42),
      p08: XCTUnimplemented("\(Self.self).p08"),
      p09: XCTUnimplemented("\(Self.self).p09"),
      p10: XCTUnimplemented("\(Self.self).p10", placeholder: 42),
      p11: XCTUnimplemented("\(Self.self).p11"),
      p12: XCTUnimplemented("\(Self.self).p12"),
      p13: XCTUnimplemented("\(Self.self).p13", placeholder: 42),
      p14: XCTUnimplemented("\(Self.self).p14"),
      p15: XCTUnimplemented("\(Self.self).p15"),
      p16: XCTUnimplemented("\(Self.self).p16", placeholder: 42),
      p17: XCTUnimplemented("\(Self.self).p17"),
      p18: XCTUnimplemented("\(Self.self).p18"),
      p19: XCTUnimplemented("\(Self.self).p19", placeholder: 42),
      p20: XCTUnimplemented("\(Self.self).p20"),
      p21: XCTUnimplemented("\(Self.self).p21"),
      p22: XCTUnimplemented("\(Self.self).p22", placeholder: 42),
      p23: XCTUnimplemented("\(Self.self).p23"),
      p24: XCTUnimplemented("\(Self.self).p24"),
      p25: XCTUnimplemented("\(Self.self).p25", placeholder: 42),
      p26: XCTUnimplemented("\(Self.self).p26"),
      p27: XCTUnimplemented("\(Self.self).p27"),
      p28: XCTUnimplemented("\(Self.self).p28", placeholder: 42),
      p29: XCTUnimplemented("\(Self.self).p29"),
      p30: XCTUnimplemented("\(Self.self).p30"),
      p31: XCTUnimplemented("\(Self.self).p31", placeholder: 42),
      p32: XCTUnimplemented("\(Self.self).p32"),
      p33: XCTUnimplemented("\(Self.self).p33"),
      p34: XCTUnimplemented("\(Self.self).p34", placeholder: 42),
      p35: XCTUnimplemented("\(Self.self).p35")
    )
  }

  static var unimplementedB: Self {
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
      p23: XCTUnimplemented("\(Self.self).p23"),
      p24: XCTUnimplemented("\(Self.self).p24"),
      p25: XCTUnimplemented("\(Self.self).p25"),
      p26: XCTUnimplemented("\(Self.self).p26"),
      p27: XCTUnimplemented("\(Self.self).p27"),
      p28: XCTUnimplemented("\(Self.self).p28"),
      p29: XCTUnimplemented("\(Self.self).p29"),
      p30: XCTUnimplemented("\(Self.self).p30"),
      p31: XCTUnimplemented("\(Self.self).p31"),
      p32: XCTUnimplemented("\(Self.self).p32"),
      p33: XCTUnimplemented("\(Self.self).p33"),
      p34: XCTUnimplemented("\(Self.self).p34"),
      p35: XCTUnimplemented("\(Self.self).p35")
    )
  }
}
