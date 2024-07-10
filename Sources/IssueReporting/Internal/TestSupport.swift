@_silgen_name(
  "$s25IssueReportingTestSupport07_recordA07message6fileID0G4Path4line6columnySSSg_S2SS2itF"
)
@usableFromInline
func _recordIssue(
  message: String?,
  fileID: String,
  filePath: String,
  line: Int,
  column: Int
)

@_silgen_name(
  "$s25IssueReportingTestSupport010_withKnownA0_14isIntermittent_ySSSg_SbyyKXEtF"
)
@usableFromInline
func _withKnownIssue(
  _ message: String?,
  isIntermittent: Bool,
  _ body: () throws -> Void
)

@_silgen_name("$s25IssueReportingTestSupport20_testCurrentIsNotNilSbyF")
func _testCurrentIsNotNil() -> Bool

@_silgen_name(
  "$s25IssueReportingTestSupport8_XCTFail_4file4lineySS_s12StaticStringVSutF"
)
@usableFromInline
func _XCTFail(_ message: String, file: StaticString, line: UInt)

@_silgen_name(
  "$s25IssueReportingTestSupport17_XCTExpectFailure_6strict12failingBlockySSSg_SbSgyyKXEtKF"
)
@usableFromInline
func _XCTExpectFailure(
  _ failureReason: String?,
  strict: Bool?,
  failingBlock: () throws -> Void
) rethrows
