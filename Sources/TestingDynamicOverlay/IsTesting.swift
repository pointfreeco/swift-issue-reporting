#if os(WASI)
  public let isTesting = false
#else
  import Foundation

  public let isTesting = ProcessInfo.processInfo.isTesting // TODO: || TestContext.current != nil

  private extension ProcessInfo {
    var isTesting: Bool {
      if environment.keys.contains("XCTestBundlePath") { return true }
      if environment.keys.contains("XCTestConfigurationFilePath") { return true }
      if environment.keys.contains("XCTestSessionIdentifier") { return true }
      if let argument = arguments.first {
        let path = URL(fileURLWithPath: argument)
        if path.lastPathComponent == "xctest" { return true }
      }
      if let argument = arguments.last {
        let path = URL(fileURLWithPath: argument)
        if path.pathExtension == "xctest" { return true }
      }
      return false
    }
  }
#endif
