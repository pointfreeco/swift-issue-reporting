import Foundation

#if canImport(os)
  import os
#endif

extension IssueReporter where Self == RuntimeWarningReporter {
  /// An issue reporter that emits "purple" runtime warnings to Xcode and logs fault-level messages
  /// to the console.
  ///
  /// This is the default issue reporter. On non-Apple platforms it logs messages to `stderr`.
  ///
  /// If this issue reporter receives an expected issue, it will log an info-level message to the
  /// console, instead.
  #if canImport(Darwin)
    @_transparent
  #endif
  public static var runtimeWarning: Self { Self() }
}

/// A type representing an issue reporter that emits "purple" runtime warnings to Xcode and logs
/// fault-level messages to the console.
///
/// Use ``IssueReporter/runtimeWarning`` to create one of these values.
public struct RuntimeWarningReporter: IssueReporter {
  #if canImport(os)
    @UncheckedSendable
    #if canImport(Darwin)
      @_transparent
    #endif
    @usableFromInline var dso: UnsafeRawPointer

  #if canImport(Darwin)
    @_transparent
  #endif
  @usableFromInline
    init() {
      // NB: Xcode runtime warnings offer a much better experience than traditional assertions and
      //     breakpoints, but Apple provides no means of creating custom runtime warnings ourselves.
      //     To work around this, we hook into SwiftUI's runtime issue delivery mechanism, instead.
      //
      // Feedback filed: https://gist.github.com/stephencelis/a8d06383ed6ccde3e5ef5d1b3ad52bbc
      let count = _dyld_image_count()
      self.dso = #dsohandle
      for i in 0..<count {
        if let name = _dyld_get_image_name(i) {
          let swiftString = String(cString: name)
          if swiftString.hasSuffix("/SwiftUI") {
            if let header = _dyld_get_image_header(i) {
              self.dso = UnsafeRawPointer(header)
              return
            }
          }
        }
      }
    }
  #endif

  @_transparent
  public func reportIssue(
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    #if canImport(os)
      let moduleName = String(
        Substring("\(fileID)".utf8.prefix(while: { $0 != UTF8.CodeUnit(ascii: "/") }))
      )
      var message = message() ?? ""
      if message.isEmpty {
        message = "Issue reported"
      }
      os_log(
        .fault,
        dso: dso,
        log: OSLog(subsystem: "com.apple.runtime-issues", category: moduleName),
        "%@",
        "\(isTesting ? "\(fileID):\(line): " : "")\(message)"
      )
    #else
      printError("\(fileID):\(line): \(message() ?? "")")
    #endif
  }

  public func expectIssue(
    _ message: @autoclosure () -> String?,
    fileID: StaticString,
    filePath: StaticString,
    line: UInt,
    column: UInt
  ) {
    #if canImport(os)
      let moduleName = String(
        Substring("\(fileID)".utf8.prefix(while: { $0 != UTF8.CodeUnit(ascii: "/") }))
      )
      var message = message() ?? ""
      if message.isEmpty {
        message = "Issue expected"
      }
      os_log(
        .info,
        log: OSLog(subsystem: "co.pointfree.expected-issues", category: moduleName),
        "%@",
        "\(isTesting ? "\(fileID):\(line): " : "")\(message)"
      )
    #else
      print("\(fileID):\(line): \(message() ?? "")")
    #endif
  }
}
