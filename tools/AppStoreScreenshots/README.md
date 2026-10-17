# Easy Units App Store screenshots

Local proposal prepared October 17, 2026. **Approved by Don Noel; all eight screenshots uploaded with 2.2 (3), now Waiting for Review.**

Review gallery and preserved assets: `docs/app-store/screenshot-redesign-2026-10-17/`.

## Capture

The existing screenshot test was replaced with a deterministic capture workflow in `ConversionUITests/ScreenshotTests.swift`. It uses the real app, its existing reset/input-seeding launch arguments, and XCTest taps. It captures four scenarios on each platform:

1. 100 kph → 62.137 mph on the main converter.
2. One cup converted to related volume units in Toolkit.
3. Three favorites selected through the real Units screen.
4. The actual Choose Units picker and search control.

No app code or behavior is modified. The native iPad floating tabs are located separately from a phone-only tab-bar query. All captures use light appearance and portrait orientation. System status bars were set to 9:41 before capture; the renderer crops system status chrome from the proposals.

Run this existing screenshot workflow on the selected simulator, substituting its current UDID and a fresh result path:

```sh
xcrun simctl ui SIMULATOR_ID appearance light
xcrun simctl status_bar SIMULATOR_ID override --time '9:41' --dataNetwork wifi --wifiMode active --wifiBars 3 --batteryState charged --batteryLevel 100
xcodebuild -project Conversion.xcodeproj -scheme Conversion -configuration Release \
  -destination 'platform=iOS Simulator,id=SIMULATOR_ID' \
  -derivedDataPath .build/AppStoreScreenshots \
  -resultBundlePath .build/StoreCaptures-PLATFORM.xcresult \
  -parallel-testing-enabled NO \
  -only-testing:ConversionUITests/ScreenshotTests/test_appStoreCaptures \
  ENABLE_TESTABILITY=YES SWIFT_TREAT_WARNINGS_AS_ERRORS=YES GCC_TREAT_WARNINGS_AS_ERRORS=YES test
xcrun xcresulttool export attachments --path .build/StoreCaptures-PLATFORM.xcresult --output-path .build/captures-PLATFORM
```

`ENABLE_TESTABILITY=YES` applies only to this simulator capture invocation; no production build setting changed. Map exported attachment names to `raw/iphone-{convert,toolkit,favorites,choose}.png` or the equivalent iPad filenames using the XCTest attachment manifest. Do not silently replace approved raw files.

## Compose and review

The renderer uses only AppKit, ImageIO, and UniformTypeIdentifiers. It adds captions and a pale canvas around unmodified screenshot crops. The iPad picker uses a tighter crop of its actual modal, recorded exactly in the manifest; no in-app control is reconstructed, painted out, or moved. Phone screenshot four puts its caption below the capture. iPad uses wider single-line captions and a more compact header.

```sh
swiftc -warnings-as-errors tools/AppStoreScreenshots/render.swift -o .build/render-store-screenshots
.build/render-store-screenshots
python3 -m http.server 8768 --bind 127.0.0.1 --directory docs/app-store/screenshot-redesign-2026-10-17
```

Open `http://127.0.0.1:8768/`. The gallery supports enlarged previews and keyboard navigation. Both contact sheets and full-resolution exports are preserved alongside the raw captures, captions/source crops, and SHA-256 validation record.

Output sizes: four iPhone PNGs at 1320 × 2868 and four iPad PNGs at 2064 × 2752. These are accepted by Apple's current screenshot specifications, checked October 17, 2026. PNGs must be opaque; the renderer creates 8-bit sRGB RGB images without alpha. At upload, preserve English (U.S.), existing previews and smaller-size inheritance, verifying the required iPhone medium-display view after saving.

https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications

## Publishing boundary and version convention

App Store Connect app `6761770180` (Easy Units), bundle `dn.conversion`, is published as **2.1.1 (2), Ready for Distribution**, with no editable pending version as inspected October 17. The user requested alignment with the other apps' two-part marketing versions. The selected marketing version is **2.2** and the processed/submitted build is **3**. On retry, check live state before any version, upload, or submission change.

After approval, the smallest publishing step is a version-only binary update: a new editable 2.2 version plus a matching 2.2 archive/build made from the same app behavior, then approved screenshot replacement and review submission. An already-published 2.1.1 binary cannot be resubmitted as a 2.2 binary. After approval, version 2.2 was created and a production 2.2 (3) archive was verified and uploaded. All eight approved screenshots were uploaded, inheritance checked, and both Add for Review and final Submit for Review completed. Exact 2.2 (3) is Waiting for Review. Keep the automation paused.
