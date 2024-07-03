# ``IssueReporting``

Report issues in your application and library code as Xcode runtime warnings, test failures, and
more.

## Overview

This library provides robust tools for reporting issues in your application with a varying degree
of granularity and severity. In its most basic for you can use the unified 
``reportIssue(_:fileID:filePath:line:column:)`` function anywhere in your application to flag an
issue with your code, such as a code path that you think should never be callable:

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
your own custom issue reporter.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:WritingTestHelpers>

### Reporting issues

- ``reportIssue(_:fileID:filePath:line:column:)``
- ``withExpectedIssue(_:isIntermittent:fileID:filePath:line:column:_:)``

### Custom reporting

- ``IssueReporter``
- ``withIssueReporters(_:operation:)-91179``
- ``withIssueContext(fileID:filePath:line:column:operation:)-97lux``
- ``IssueReporters``

### Testing

- ``isTesting``
- ``TestContext``
