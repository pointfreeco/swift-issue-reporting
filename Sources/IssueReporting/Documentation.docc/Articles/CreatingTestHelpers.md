# Creating testing tools

Learn how to build testing tools in your libraries using IssueReporting.

## Overview

It is common for libraries to provide a set of tools that help one test code that is using said
library. For example, in the [Composable Architecture][tca-gh] we provide a `TestStore` tool that
allows one to test their features. It allows you to send actions to the store and assert on how 
state changes.

[tca-gh]: https://github.com/pointfreeco/swift-composable-architecture
