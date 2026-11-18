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
    func testTinyResultAndCopyConfirmationInConversionAndToolkit() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing-reset-state", "-ui-testing-seed-converter", "data.kb-mb", "0.1"]
        app.launch()

        let converterCopy = app.buttons["converter.output.copy"]
        XCTAssertTrue(converterCopy.waitForExistence(timeout: 5))
        XCTAssertTrue(converterCopy.label.contains("0.0001"))
        converterCopy.tap()
        XCTAssertEqual(converterCopy.value as? String, "Copied")

        app.buttons["converter.openToolkit"].tap()
        let toolkitCopy = app.buttons["toolkit.output.GB"]
        scrollToElementIfNeeded(toolkitCopy, in: app)
        XCTAssertTrue(toolkitCopy.isHittable, app.debugDescription)
        XCTAssertTrue(toolkitCopy.label.contains("0.0000001"))
        toolkitCopy.tap()
        XCTAssertEqual(toolkitCopy.value as? String, "Copied")
    }

    @MainActor
    func testBothSearchSurfacesFindFullUnitNames() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing-reset-state"]
        app.launch()

        app.buttons["converter.choosePair.length.cm-in"].tap()
        let pickerSearch = app.searchFields.firstMatch
        XCTAssertTrue(pickerSearch.waitForExistence(timeout: 5))
        pickerSearch.tap()
        pickerSearch.typeText("kilometers per hour")
        let pickerSpeed = app.buttons["converter.picker.row.speed.mph-kph"]
        XCTAssertTrue(pickerSpeed.waitForExistence(timeout: 5))
        pickerSpeed.tap()

        app.buttons["Units"].firstMatch.tap()
        let unitsSearch = app.searchFields.firstMatch
        XCTAssertTrue(unitsSearch.waitForExistence(timeout: 5))
        unitsSearch.tap()
        unitsSearch.typeText("kilometers per hour")
        XCTAssertTrue(app.buttons["units.row.speed.mph-kph"].waitForExistence(timeout: 5))
        unitsSearch.typeText(" unlikely unit")
        let emptyState = app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH[c] %@", "No Results")).firstMatch
        XCTAssertTrue(emptyState.waitForExistence(timeout: 5))
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
