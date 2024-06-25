# ``IssueReporting``

Report issues in your application and library code as Xcode runtime warnings, test failures, and
more.

## Overview

<!-- TODO: Paste from README -->

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
