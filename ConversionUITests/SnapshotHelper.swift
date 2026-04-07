import XCTest
import Foundation

@MainActor
func setupSnapshot(_ app: XCUIApplication) {
    // Signal app we are in screenshot mode
    app.launchEnvironment["FASTLANE_SNAPSHOT"] = "YES"
}

@MainActor
func snapshot(_ name: String) {
    print("📸 Custom snapshot running: \(name)")

    let screenshot = XCUIScreen.main.screenshot()
    let image = screenshot.image

    // 🔑 Absolute path (no ambiguity)
    let dir = "/Users/donnoel/Development/Conversion/fastlane/screenshots/en-US"

    let fm = FileManager.default
    try? fm.createDirectory(atPath: dir, withIntermediateDirectories: true)

    let path = "\(dir)/\(name).png"
    if let data = image.pngData() {
        try? data.write(to: URL(fileURLWithPath: path))
    }

    // Keep attachment for Xcode viewer
    let attachment = XCTAttachment(screenshot: screenshot)
    attachment.name = name
    attachment.lifetime = .keepAlways

    XCTContext.runActivity(named: "Snapshot: \(name)") { activity in
        activity.add(attachment)
    }
}
