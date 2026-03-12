import XCTest

final class ConversionUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testInlineConversionAndFavoriteAppearsInFavoritesTab() throws {
        let app = XCUIApplication()
        app.launchArguments.append("-ui-testing-reset-state")
        app.launch()

        let inputField = app.textFields["Value"].firstMatch
        XCTAssertTrue(inputField.waitForExistence(timeout: 5))
        inputField.tap()
        inputField.typeText("10")

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

        let favoritesList = app.scrollViews["favorites.list"]
        XCTAssertTrue(favoritesList.waitForExistence(timeout: 5))
        XCTAssertFalse(app.otherElements["favorites.empty"].exists)
        XCTAssertTrue(favoritesList.staticTexts["cm <-> inches"].waitForExistence(timeout: 5))
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
