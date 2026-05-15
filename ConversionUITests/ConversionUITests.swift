import XCTest

final class ConversionUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testInlineConversionFavoriteAndUnitSelectionFlow() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-ui-testing-reset-state")
        app.launchArguments += ["-ui-testing-seed-converter", "length.cm-in", "10"]
        app.launch()

        let outputValue = app.staticTexts["3.937"]
        XCTAssertTrue(outputValue.waitForExistence(timeout: 3))

        let unitsTab = app.tabBars.buttons["Units"]
        XCTAssertTrue(unitsTab.waitForExistence(timeout: 2))
        unitsTab.tap()

        let lengthRow = app.descendants(matching: .any)["units.row.length.cm-in"]
        // Ensure the list is scrolled so the length row can appear
        scrollToElementIfNeeded(lengthRow, in: app)
        XCTAssertTrue(lengthRow.waitForExistence(timeout: 10), "Expected length row to exist after navigating to Units and scrolling")

        let unitsFavoriteButton = app.descendants(matching: .any)["units.favorite.length.cm-in"]
        XCTAssertTrue(unitsFavoriteButton.waitForExistence(timeout: 5))
        unitsFavoriteButton.tap()

        let speedRow = app.descendants(matching: .any)["units.row.speed.mph-kph"]
        scrollToElementIfNeeded(speedRow, in: app)
        XCTAssertTrue(speedRow.waitForExistence(timeout: 10), "Expected speed row to exist after favoriting length and scrolling")
    }

    @MainActor
    private func dismissKeyboardIfNeeded(in app: XCUIApplication) {
        guard app.keyboards.count > 0 else { return }

        let doneButton = app.keyboards.buttons["Done"]
        if doneButton.exists {
            doneButton.tap()
            return
        }

        let returnButton = app.keyboards.buttons["return"]
        if returnButton.exists {
            returnButton.tap()
            return
        }

        app.tap()
    }

    @MainActor
    private func scrollToElementIfNeeded(_ element: XCUIElement, in app: XCUIApplication) {
        // If it already exists and is hittable, nothing to do
        if element.exists && element.isHittable { return }

        // Prefer scrolling within a specific scrollable container if present
        let scrollable = app.scrollViews.firstMatch.exists ? app.scrollViews.firstMatch : (app.tables.firstMatch.exists ? app.tables.firstMatch : app)

        // Try a few times to bring the element into view
        var attempts = 0
        while attempts < 10 && !(element.exists && element.isHittable) {
            if !element.exists {
                // Give the UI a moment to lay out or load
                _ = element.waitForExistence(timeout: 1)
            }
            scrollable.swipeUp()
            attempts += 1
        }
    }

}
