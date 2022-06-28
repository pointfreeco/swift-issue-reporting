import Foundation

public let _XCTIsTesting: Bool = {
  guard let path = ProcessInfo.processInfo.arguments.first
  else { return false }

  let url = URL(fileURLWithPath: path)
  return url.lastPathComponent == "xctest" || url.pathExtension == "xctest"
}()
