import XCTest

final class ConversionUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testInlineConversionAndFavoriteAppearsInFavoritesTab() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-ui-testing-reset-state")
        app.launchArguments += ["-ui-testing-seed-converter", "length.cm-in", "10"]
        app.launch()

        let outputValue = app.staticTexts["3.937008"]
        XCTAssertTrue(outputValue.waitForExistence(timeout: 3))

        let addFavoriteButton = app.buttons["Add cm and inches to favorites"]
        if addFavoriteButton.waitForExistence(timeout: 2) {
            addFavoriteButton.tap()
        } else {
            XCTAssertTrue(app.buttons["Remove cm and inches from favorites"].waitForExistence(timeout: 2))
        }

        dismissKeyboardIfNeeded(in: app)

        let favoritesTab = app.tabBars.buttons["Favorites"]
        XCTAssertTrue(favoritesTab.waitForExistence(timeout: 2))
        favoritesTab.tap()

        XCTAssertFalse(app.staticTexts["No Favorites Yet"].waitForExistence(timeout: 1))
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

}
