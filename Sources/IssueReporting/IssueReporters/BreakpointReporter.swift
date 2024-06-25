#if canImport(Darwin)
  import Darwin

  extension IssueReporter where Self == BreakpointReporter {
    public static var breakpoint: Self { Self() }
  }

  public struct BreakpointReporter: IssueReporter {
    public func reportIssue(
      _ message: @autoclosure () -> String,
      fileID: StaticString,
      filePath: StaticString,
      line: UInt,
      column: UInt
    ) {
      fputs(
        """
        \(fileID):\(line): \(message())

        Caught debug breakpoint. Type "continue" ("c") to resume execution.

        """,
        stderr
      )
      raise(SIGTRAP)
    }

    var isDebuggerAttached: Bool {
      var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
      var info: kinfo_proc = kinfo_proc()
      var info_size = MemoryLayout<kinfo_proc>.size

      return name.withUnsafeMutableBytes {
        $0.bindMemory(to: Int32.self).baseAddress
          .map {
            sysctl($0, 4, &info, &info_size, nil, 0) != -1 && info.kp_proc.p_flag & P_TRACED != 0
          }
          ?? false
      }
    }
  }
#endif
