// NB: Deprecated after 1.7.0

extension IssueReporter where Self == _DefaultReporter {
  @available(*, deprecated, renamed: "default")
  #if canImport(Darwin)
    @_transparent
  #endif
  public static var runtimeWarning: Self { Self() }
}

@available(*, unavailable, renamed: "_DefaultReporter")
public typealias _RuntimeWarningReporter = _DefaultReporter

// NB: Deprecated after 1.2.2

#if canImport(Darwin)
  @available(*, unavailable, renamed: "_BreakpointReporter")
  public typealias BreakpointReporter = _BreakpointReporter
#endif

@available(*, unavailable, renamed: "_FatalErrorReporter")
public typealias FatalErrorReporter = _FatalErrorReporter

@available(*, unavailable, renamed: "_RuntimeWarningReporter")
public typealias RuntimeWarningReporter = _DefaultReporter
