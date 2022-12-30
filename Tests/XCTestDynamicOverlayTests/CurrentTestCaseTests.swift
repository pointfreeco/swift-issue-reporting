@_spi(CurrentTestCase) import XCTestDynamicOverlay

// Make sure XCTCurrentTestCase is visible to SPI.
private let currentTestCase = XCTCurrentTestCase
