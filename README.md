# Swift Issue Reporting

[![CI](https://github.com/pointfreeco/xctest-dynamic-overlay/actions/workflows/ci.yml/badge.svg)](https://github.com/pointfreeco/xctest-dynamic-overlay/actions/workflows/ci.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpointfreeco%2Fxctest-dynamic-overlay%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/pointfreeco/xctest-dynamic-overlay)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpointfreeco%2Fxctest-dynamic-overlay%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/pointfreeco/xctest-dynamic-overlay)

Report issues in your application and library code as Xcode runtime warnings, breakpoints, 
assertions, and do so in a testable manner.

## Overview

This library provides robust tools for reporting issues in your application with a customizable
degree of granularity and severity. In its most basic for you use the unified 
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

// TODO: test failure image

// TODO: link to get started article

## Case studies

There are many popular libraries out there using Swift Issue Reporting. To name a few:

<!-- TODO: Order? -->
<!-- TODO: Rewrite for SwiftUI Navigation if Swift Issue Reporting is released first -->

  * [**Perception**](https://github.com/pointfreeco/swift-perception) is a back-port of Swift's
    Observation framework that can be deployed all the way back to the iOS 13 generation of devices.
    It provides a special SwiftUI view that can observe changes to objects annotated with the macro,
    and uses Swift Issue Reporting to warn developers when this view is missing.

  * [**Swift Dependencies**](https://github.com/pointfreeco/swift-dependencies) is a general purpose
    dependency injection tool inspired by SwiftUI's environment. It uses Swift Issue Reporting to
    notify users when they haven't asserted against how a dependency is used. This forces each test
    to explicitly declare its dependencies, and when a new dependency is introduced to a feature,
    existing tests will fail until they account for it.

  * [**Swift Navigation**](https://github.com/pointfreeco/swiftui-navigation) provides concise
    domain modeling tools for UI frameworks including SwiftUI, UIKit, and more; and it uses Swift
    Issue Reporting to raise runtime warnings when APIs are used in unexpected ways.

  * [**The Composable Architecture**](https://github.com/pointfreeco/swift-composable-architecture)
    comes with powerful testing tools that support both Swift Testing and XCTest out of the box
    thanks to Swift Issue Reporting. In addition, the library is heavily instrumented with issue
    reporting to help developers catch bugs in their code early.

  * [**Swift Custom Dump**](https://github.com/pointfreeco/swift-custom-dump) is an improved version
    of Swift's `dump` function, and a whole lot more. It provides well-formatted dumps of data types
    that read like Swift code, as well as well-formatted diffs when data types are compared. It also
    ships several test helpers powered by Swift Issue Reporting, including drop-in replacements for
    `#expect(_ == _)` and `XCTAssertEqual` that render failures as concise diffs, as well as helpers
    that allow you to assert against changes to data structures over time.

  * [**Swift Clocks**](https://github.com/pointfreeco/swift-clocks) and
    [**Combine Schedulers**](https://github.com/pointfreeco/combine-schedulers) are sibling packages
    that use issue reporting to drive their "test" and "unimplemented" clocks and schedulers. "Test" 
    clocks/schedulers allow you to _control time_ in tests, and will emit failures when expectations
    aren't met. "Unimplemented" clocks/schedulers record unexpected usage as issues.

<!-- TODO: The XCTest helpers are basically deprecated, and while we may add issue reporting to `modify`, it's pretty subtle to describe? -->
<!-- * [**Case Paths**](https://github.com/pointfreeco/swift-case-paths) generates key paths for enum-->
<!--   cases, which unlocks a variety of tools that close the ergonomic gap between structs and enums.-->

Have another case study to share? [Let us know!](edit/main/README.md)

## Documentation 

Full documentation can be found
[here](https://swiftpackageindex.com/pointfreeco/swift-issue-reporting/main/documentation).

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

---

## Sketches

Swift's built-in error reporting tools are rather blunt. You can use `assert`, `precondition`, or
`fatalError` to catch issues early, but at the cost of crashes that can be disruptive to your debug
sessions and unit test runs.

This library provides a single `reportIssue` function that emits "purple" runtime warnings to Xcode
while debugging your application in the simulator or on device, or test failures during test runs.
This is no simple task! Xcode provides no public interface to emit "purple" runtime warnings, and it
is not possible to `import Testing` or `import XCTest` into application or library code. This
library bridges the gap with a single interface that allows you to do both.

---

You can even use `reportIssue` to build test helpers that are agnostic to the Testing and XCTest
frameworks. Calling Testing's `#expect` from XCTest 

---

You can use this function to introduce less disruptive assertions to your debug sessions and tests,
and even super generic test helpers that emit failures in both Swift's new Testing framework as well
as XCTest.

---

This library unlocks 3 things:

  1. It allows you to emit Xcode's purple runtime warnings from your application and library code.

  2. These runtime warnings will automatically by promoted to test failures in Swift's Testing
     framework and XCTest.
     
  3. You can use this error reporting feature to write generic test helpers that work in both
     Testing _and_ XCTest.

---

Swift's built-in error reporting tools are rather blunt. You can use `assert`, `precondition`, or
`fatalError` to catch issues early, but they lead to crashes that can disrupt your debugging and
unit tests.

It can be far better to surface issues while debugging using Xcode's "purple" runtime warning
machinery, or _via_ test failures.

This library provides tools to do just that!

  * First, it defines a `reportIssue` function, which reports a "purple" runtime warning and stack
    trace to Xcode when debugging the application, and reports test failures to Swift's Testing
    framework or XCTest during a test run.
    
    This function is similar to the Testing framework's `Issue.report()` function, but can be called
    from your application target, and will trigger test failures in both Testing and XCTest.

  * Second, it provides a `withExpectedIssue` function, which allows you to log or suppress reported
    issues, much like the `withKnownIssue` function from the Testing framework.

These two functions can be employed by your applications and libraries to better catch problems when
debugging and testing them.

## Old

It is very common to write test support code for libraries and applications. This often comes in the
form of little domain-specific functions or helpers that make it easier for users of your code to
formulate assertions on behavior.

Currently there are only two options for writing test support code:

  * Put it in a test target, but then you can't access it from multiple other test targets. For
    whatever reason test targets cannot be imported, and so the test support code will only be
    available in that one single test target.

  * Create a dedicated test support module that ships just the test-specific code. Then you can
    import this module into as many test targets as you want, while never letting the module
    interact with your regular, production code.

Neither of these options is ideal. In the first case you cannot share your test support, and the
second case will lead you to a proliferation of modules. For each feature you potentially need 3
modules: `MyFeature`, `MyFeatureTests` and `MyFeatureTestSupport`. SPM makes managing this quite
easy, but it's still a burden.

It would be far better if we could ship the test support code right along side or actual library or
application code. After all, they are intimately related. You can even fence off the test support
code in `#if DEBUG ... #endif` if you are worried about leaking test code into production.

However, as soon as you add `import XCTest` to a source file in your application or a library it
loads, the target becomes unbuildable:

```swift
import XCTest
```

> 🛑 ld: warning: Could not find or use auto-linked library 'XCTestSwiftSupport'
>
> 🛑 ld: warning: Could not find or use auto-linked framework 'XCTest'

This is due to a confluence of problems, including test header search paths, linker issues, and more. XCTest just doesn't seem to be built to be loaded alongside your application or library code.

So, the XCTest Dynamic Overlay library is a microlibrary that dynamically loads the `XCTFail` symbol
at runtime and exposes it publicly so that it can be used from anywhere. This means you can import
this library instead of XCTest:

```swift
import XCTestDynamicOverlay // ✅
```

…and your application or library will continue to compile just fine.


## Example

A real world example of using this is in our library, the [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture). That library vends a `TestStore` type whose purpose is to make it easy to write tests for your application's logic. The `TestStore` uses `XCTFail` internally, and so that forces us to move the code to a dedicated test support module. However, due to how SPM works you cannot currently have that module in the same package as the main module, and so we would be forced to extract it to a separate _repo_. By loading `XCTFail` dynamically we can keep the code where it belongs.

As another example, let's say you have an analytics dependency that is used all over your application:

```swift
struct AnalyticsClient {
  var track: (Event) -> Void

  struct Event: Equatable {
    var name: String
    var properties: [String: String]
  }
}
```

If you are disciplined about injecting dependencies, you probably have a lot of objects that take an analytics client as an argument (or maybe some other fancy form of DI):

```swift
class LoginViewModel: ObservableObject {
  // ...

  init(analytics: AnalyticsClient) {
    // ...
  }

  // ...
}
```

When testing this view model you will need to provide an analytics client. Typically this means you will construct some kind of "test" analytics client that buffers events into an array, rather than sending live events to a server, so that you can assert on what events were tracked during a test:

```swift
func testLogin() {
  var events: [AnalyticsClient.Event] = []
  let viewModel = LoginViewModel(
    analytics: .test { events.append($0) }
  )

  // ...

  XCTAssertEqual(events, [.init(name: "Login Success")])
}
```

This works really well, and it's a great way to get test coverage on something that is notoriously difficult to test.

However, some tests may not use analytics at all. It would make the test suite stronger if the tests that don't use the client could prove that it's never used. This would mean when new events are tracked you could be instantly notified of which test cases need to be updated.

One way to do this is to create an instance of the `AnalyticsClient` type that simply performs an `XCTFail` inside the `track` endpoint:

```swift
import XCTest

extension AnalyticsClient {
  static let testValue = Self(
    track: { _ in XCTFail("\(Self.self).track is unimplemented.") }
  )
}
```

With this you can write a test that proves analytics are never tracked, and even better you don't have to worry about buffering events into an array anymore:

```swift
func testValidation() {
  let viewModel = LoginViewModel(
    analytics: .testValue
  )

  // ...
}
```

However, you cannot ship this code with the target that defines `AnalyticsClient`. You either need to extract it out to a test support module (which means `AnalyticsClient` must also be extracted), or the code must be confined to a test target and thus not shareable.

With XCTest Dynamic Overlay we can have our cake and eat it too 😋. We can define both the client type and the unimplemented test instance right next to each in application code without needing to extract out needless modules or targets:

```swift
struct AnalyticsClient {
  var track: (Event) -> Void

  struct Event: Equatable {
    var name: String
    var properties: [String: String]
  }
}

import XCTestDynamicOverlay

extension AnalyticsClient {
  static let testValue = Self(
    track: { _ in XCTFail("\(Self.self).track is unimplemented.") }
  )
}
```

XCTest Dynamic Overlay also comes with a helper that simplifies this exact pattern: `unimplemented`. It creates failing closures for you:

```swift
extension AnalyticsClient {
  static let testValue = Self(
    track: unimplemented("\(Self.self).track")
  )
}
```

And it can simplify the work of more complex dependency endpoints, which can throw or need to return a value:

```swift
struct AppDependencies {
  var date: () -> Date = Date.init,
  var fetchUser: (User.ID) async throws -> User,
  var uuid: () -> UUID = UUID.init
}

extension AppDependencies {
  static let testValue = Self(
    date: unimplemented("\(Self.self).date", placeholder: Date()),
    fetchUser: unimplemented("\(Self.self).fetchUser"),
    uuid: unimplemented("\(Self.self).uuid", placeholder: UUID())
  )
}
```

The above `placeholder` parameters can be left off, but will fatal error when the endpoint is called.
