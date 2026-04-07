import XCTest

@MainActor
final class ScreenshotTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func test_screenshots() {
        let app = XCUIApplication()
        setupSnapshot(app)

        app.launch()

        // Handle unexpected alert (your log popup)
        if app.alerts.firstMatch.waitForExistence(timeout: 2) {
            app.alerts.buttons.firstMatch.tap()
        }

        // Wait for UI to be ready
        XCTAssertTrue(app.windows.firstMatch.waitForExistence(timeout: 5))

        // MARK: - Screenshot 1
        snapshot("01-home")

        // MARK: - Example additional screens (safe, optional)
        if app.buttons["Convert"].exists {
            app.buttons["Convert"].tap()
            sleep(1)
            snapshot("02-conversion")
        }

        if app.buttons["Results"].exists {
            app.buttons["Results"].tap()
            sleep(1)
            snapshot("03-results")
        }
    }
}
