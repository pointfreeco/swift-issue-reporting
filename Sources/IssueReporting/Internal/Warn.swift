#if canImport(Foundation)
#if os(Linux)
  @preconcurrency import Foundation
#else
  import Foundation
#endif
#endif

#if canImport(WinSDK)
  import WinSDK
#endif

@usableFromInline
func printError(_ message: String) {
#if canImport(Foundation)
  fputs("\(message)\n", stderr)
  #endif
}
