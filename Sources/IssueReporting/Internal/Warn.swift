import Foundation

func warn(_ message: String) {
  #if os(Linux) || os(macOS)
    fputs("\(message)\n", stderr)
  #else
    // TODO: Print to `stderr` on Windows?
    print(message)
  #endif
}
