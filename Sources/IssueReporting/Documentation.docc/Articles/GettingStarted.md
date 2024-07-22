# Getting started

Learn how to report issues in your application code, and how to customize how issues are reported.

## Reporting issues

The primary tool for reporting an issue in your application code is the 
[`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>) function. You can invoke from
anywhere with your features' code to signal that something happened that should not have:

```swift
guard let lastItem = items.last
else {
  reportIssue("'items' should never be empty.")
  return 
}
// ...
```

By default, [`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>) will trigger an
unobtrusive, purple runtime warning when running your app in Xcode (simulator and device):

![A purple runtime warning in Xcode showing that an issue has been reported.](runtime-warning)

This provides a very visible way to see when an issue has occured in your application without
stopping the app's execution and interrupting your workflow.

The [`reportIssue`](<doc:reportIssue(_:fileID:filePath:line:column:)>) tool can also be customized
to allow for other ways of reporting issues. It can be configured to trigger a breakpoint if you
want to do some debugging when an issue is reported, or a precondition or fatal error if you want
to truly stop execution. And you can create your own custom issue reporter to send issues to OSLog 
or an external server. 

Further, when running your code in a testing context (both XCTest and Swift's native Testing
framework), all reported issues become _test failures_. This helps you get test coverage that
problematic code paths are not executed, and makes it possible to build testing tools for libraries
that ship in the same target as the library itself.

![A test failure in Xcode where an issue has been reported.](test-failure)

## Issue reporters

The library comes with a variety of issue reporters that can be used right away:

  * ``IssueReporter/runtimeWarning``: Issues are reported as purple runtime warnings in Xcode and
    printed to the console on all other platforms. This is the default reporter.
  * ``IssueReporter/breakpoint``: A breakpoint is triggered, stopping execution of your app. This
    gives you the ability to debug the issue.
  * ``IssueReporter/fatalError``: A fatal error is raised and execution of your app is permanently
    stopped.

You an also create your own custom issue reporter by defining a type that conforms to the 
``IssueReporter`` protocol. It has one requirement,
``IssueReporter/reportIssue(_:fileID:filePath:line:column:)``, which you can implement to report
issues in any way you want.

## Overridding issue reporters

By default the library uses the ``IssueReporter/runtimeWarning`` reporter, but it is possible to 
override the reporters used. There are two primary ways:

  * You can temporarily override reporters for a lexical scope using
    ``withIssueReporters(_:operation:)-91179``. For example, to turn off reporting entirely you can
    do:

    ```swift
    withIssueReporters([]) {
      // Any issues raised here will not be reported.
    }
    ```

    …or to temporarily add a new issue reporter:

    ```swift
    withIssueReporters(IssueReporters.current + [.breakpoint]) {
      // Any issues reported here will trigger a breakpoint
    }
    ```

  * You can also override the issue reporters globally by setting the ``IssueReporters/current``
    variable. This is typically best done at the entry point of your application:

    ```swift
    import IssueReporting
    import SwiftUI 

    @main
    struct MyApp: App {
      init() {
        IssueReporters.current = [.fatalError]
      }
      var body: some Scene {
        // ...
      }
    }
    ```

## Unimplemented closures

The library also comes with a tool for marking a closure as "unimplemented" so that if it is ever
invoked it will report an issue. This can be useful for a common pattern of defining callback
closures that allow a child domain to communicate to the parent domain.

For example, suppose you have a child feature that has a delete button to delete the data associated
with the feature. However, the child feature can't actually perform the deletion itself, and 
instead needs to communicate to the parent to perform the deletion. One way to do this is to
have the child model hold onto a `onDelete` callback closure:

```swift
@Observable
class ChildModel {
  var onDelete: () -> Void

  func deleteButtonTapped() {
    onDelete()
  }
}
```

Then when the parent model creates the child model it will need to provide this closure and 
perform the actual deletion logic:

```swift
class ParentModel {
  var child: ChildModel? 

  func presentChildButtonTapped() {
    child = ChildModel(onDelete: {
      // Parent feature performs deletion logic
    })
  }
}
```

However, requiring the `onDelete` closure at the time of creating a `ChildModel` is too restrictive.
Sometimes you need to create the `ChildModel` in situations where it is not appropriate to 
provide the `onDelete` closure. For example, when deep linking into the child feature:

```swift
import SwiftUI 

@main
struct MyApp: App {
  var body: some Scene {
    ParentView(
      model: ParentModel(
        child: ChildModel(onDelete: { /* ??? */ })
      )
    )
  }
}
```

One way to fix this is to provide a default for the closure so that it does not have to be provided
upon initializing of `ChildModel`:

```swift
@Observable
class ChildModel {
  var onDelete: () -> Void = {}
  // ...
}
```

And instead you will override the closure after creating the model:

```swift
func presentChildButtonTapped() {
  child = ChildModel()
  child.onDelete = {
    // Parent feature performs deletion logic
  }
}
```

But now this is to lax. It is not possible to create a `ChildModel` without ever overriding
the `onDelete` closure, which will subtly break your feature.

The fix is to strike a balance between the restrictiveness of requiring the closure and the
laxness of making it fully optional. By using the library's
[`unimplemented`](<doc:unimplemented(_:fileID:filePath:function:line:column:)-1hsov>) tool we can
mark the closure as unimplemented:

```swift
@Observable
class ChildModel {
  var onDelete: () -> Void = unimplemented("onDelete")
  // ...
}
```

This means it is not required to provide this closure when creating the `ChildModel`, but if
the closure is not overridden and then invoked, it will report an issue. This will make it obvious
when you forget to override the `onDelete` closure, and allow you to fix it.
