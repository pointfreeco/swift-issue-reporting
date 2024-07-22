import IssueReporting
import SwiftUI

@main
struct ExamplesApp: App {
  let model = ItemsModel()

  var body: some Scene {
    WindowGroup {
      Text(model.lastItem?.description ?? "No last item")
    }
  }
}

@Observable
class ItemsModel {
  var items: [Int] = []

  var lastItem: Int? {
    guard let lastItem = items.last
    else {
      reportIssue("'items' should never be empty.")
      return nil
    }

    return lastItem
  }
}
