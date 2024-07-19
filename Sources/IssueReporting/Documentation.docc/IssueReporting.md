# ``IssueReporting``

Report issues in your application and library code as Xcode runtime warnings, test failures, 
breakpoints, assertions, and more.

## Overview

This library provides robust tools for reporting issues in your application with a varying degree
of granularity and severity. In its most basic for you can use the unified 
[`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>) function anywhere in your
application to flag an issue with your code, such as a code path that you think should never be
executed:

```swift
guard let lastItem = items.last
else {
  reportIssue("'items' should never be empty.")
  return 
}
…
```

By default, `reportIssue` will trigger a purple runtime warning when running in the simulator or
device, and in tests it will trigger a test failure. This gives you an unobtrusive way to see
issues while running your app, while also catching the issues in tests with explicit test failures.

The `reportIssue` tool can also be customized to allow for other ways of reporting issues beyond
runtime warnings and test failures. It can also be configured to trigger a breakpoint if you want to
do some debugging when an issue is reported, or a precondition or fatal error, or you can create
your own custom issue reporter to send issues to OSLog or an external server.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:ReleaseMode>
- <doc:CreatingTestHelpers>

### Reporting issues

- ``reportIssue(_:fileID:filePath:line:column:)``
- ``withExpectedIssue(_:isIntermittent:fileID:filePath:line:column:_:)``

### Issue reporters

- ``IssueReporter/breakpoint``
- ``IssueReporter/fatalError``
- ``IssueReporter/runtimeWarning``

### Custom reporting

- ``IssueReporter``
- ``withIssueReporters(_:operation:)-91179``
- ``withIssueContext(fileID:filePath:line:column:operation:)-97lux``
- ``IssueReporters``

### Testing

- ``isTesting``
- ``TestContext``

### Unimplemented

- ``unimplemented(_:placeholder:fileID:filePath:function:line:column:)-34tpp``
