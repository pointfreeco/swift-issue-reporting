@_spi(CurrentTestCase) import XCTestDynamicOverlay

// Make sure XCTCurrentTestCase is visible to SPI.
@MainActor private let currentTestCase = XCTCurrentTestCase
