import SwiftUI

@main
struct ConversionApp: App {
    init() {
        AppVersionDisplayWriter.updateFromBundle()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

private enum AppVersionDisplayWriter {
    private static let key = "app_version_display"
    private static let shortVersionKey = "CFBundleShortVersionString"
    private static let buildVersionKey = "CFBundleVersion"
    private static let defaultDisplayValue = "--"

    static func updateFromBundle() {
        let infoDictionary = Bundle.main.infoDictionary
        let version = infoDictionary?[shortVersionKey] as? String
        let build = infoDictionary?[buildVersionKey] as? String

        let displayValue: String
        if let version, version.isEmpty == false {
            if let build, build.isEmpty == false {
                displayValue = "\(version) (\(build))"
            } else {
                displayValue = version
            }
        } else {
            displayValue = defaultDisplayValue
        }

        UserDefaults.standard.set(displayValue, forKey: key)
    }
}
