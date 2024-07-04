# Getting Started

Learn how to report issues in your application code, and how to customize how issues are reported.

## Reporting issues

The primary tool for reporting an issue in your application code is the 
``reportIssue(_:fileID:filePath:line:column:)`` function. You can invoke from anywhere with your
features' code to signal that something happened that should not have:

```swift
guard let lastItem = items.last
else {
  reportIssue("'items' should never be empty.")
  return 
}
…
```

