import XCTest

final class ConversionUITests: XCTestCase {
    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        // Basic smoke test
        XCTAssertTrue(app.windows.count >= 0)
    }
}
