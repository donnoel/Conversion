import XCTest

/// Reproducible, genuine App Store captures. No production UI is changed.
@MainActor
final class ScreenshotTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func test_appStoreCaptures() {
        let app = XCUIApplication()
        XCUIDevice.shared.orientation = .portrait

        func launch(pair: String, value: String) {
            app.terminate()
            app.launchArguments = ["-ui-testing-reset-state", "-ui-testing-seed-converter", pair, value]
            app.launch()
            XCTAssertTrue(app.buttons["converter.openToolkit"].waitForExistence(timeout: 10))
        }
        func capture(_ name: String) {
            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = name
            attachment.lifetime = .keepAlways
            add(attachment)
        }

        launch(pair: "speed.mph-kph", value: "100")
        XCTAssertTrue(app.buttons["converter.output.copy"].exists)
        capture("01-convert")

        launch(pair: "volume.cup-tbsp", value: "1")
        app.buttons["converter.openToolkit"].tap()
        XCTAssertTrue(app.otherElements["toolkit.outputs"].waitForExistence(timeout: 5))
        capture("02-toolkit")

        launch(pair: "speed.mph-kph", value: "100")
        app.buttons["Units"].firstMatch.tap()
        let favoriteIDs = ["angle.rad-deg", "area.acre-sqft", "area.ac-ha"]
        for id in favoriteIDs {
            let button = app.buttons["units.favorite.\(id)"]
            XCTAssertTrue(button.waitForExistence(timeout: 5))
            button.tap()
        }
        capture("03-favorites")

        launch(pair: "speed.mph-kph", value: "100")
        app.buttons["converter.choosePair.speed.mph-kph"].tap()
        XCTAssertTrue(app.buttons["converter.picker.row.angle.rad-deg"].waitForExistence(timeout: 5))
        capture("04-choose")
    }
}
