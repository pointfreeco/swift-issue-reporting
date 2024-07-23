@preconcurrency import Foundation

#if canImport(WinSDK)
  import WinSDK
#endif

@usableFromInline
func printError(_ message: String) {
  fputs("\(message)\n", stderr)
}
