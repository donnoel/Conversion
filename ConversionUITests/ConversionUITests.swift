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

        let outputValue = app.staticTexts["3.937008"]
        XCTAssertTrue(outputValue.waitForExistence(timeout: 3))

        let unitsTab = app.tabBars.buttons["Units"]
        XCTAssertTrue(unitsTab.waitForExistence(timeout: 2))
        unitsTab.tap()

        let unitsFavoriteButton = app.buttons["units.favorite.length.cm-in"]
        XCTAssertTrue(unitsFavoriteButton.waitForExistence(timeout: 2))
        unitsFavoriteButton.tap()

        let speedRowLabel = app.staticTexts["mph <-> kph"]
        scrollToElementIfNeeded(speedRowLabel, in: app)
        XCTAssertTrue(speedRowLabel.waitForExistence(timeout: 2))
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
        guard !element.exists else { return }

        for _ in 0..<8 where !element.exists {
            app.swipeUp()
        }
    }

}
