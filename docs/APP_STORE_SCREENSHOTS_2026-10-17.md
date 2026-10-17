# Easy Units screenshot proposal — October 17, 2026

Status: **Submitted — Waiting for Review**. Don approved the gallery and authorized submission, commit and push. Published 2.1.1 had no editable version, so the authorized update is 2.2 (3).

## App and live release

- Selected repository: `/Users/donnoel/Development/Conversion`; `main` tracking `github/main`.
- Easy Units, iPhone/iPad; production scheme Conversion / Release, team H7LG8SK72M, bundle dn.conversion. No tvOS, watchOS, or independent macOS target exists in this repository.
- App Store Connect app 6761770180: **2.1.1 (2), Ready for Distribution**, with no editable pending version visible October 17.
- https://appstoreconnect.apple.com/apps/6761770180/distribution/ios/version/deliverable
- Existing English (U.S.) screenshot lineup: three iPhone images, inherited in the medium-display view, and three iPad 13-inch images. Inspected all iPhone images enlarged and the full iPad lineup. The old set uses heavy device borders, oversized serif branding, an empty converter, older UI, and long Toolkit number formatting.

## Proposal

Four images per platform, eight total. Light blue/lilac/white, navy system typography, restrained blue branding. Genuine app imagery occupies most of each composition, without hardware frames, reflection, generated art, or simulated controls.

1. Everyday units. Instant answers. — populated 100 kph → 62.137 mph.
2. One value. Related units. — actual Toolkit results for one cup.
3. Your favorites, ready to use. — actual favorite selections at the top of Units.
4. Find the right units. — genuine unit picker and search control.

The first three move from the core task to related results to personal shortcuts. Phone four moves the caption below the picker. iPad uses compact wide headings and a tighter genuine picker crop, rather than stretching the phone images. Exact crop rectangles, captions, and source files are in the manifest.

Gallery: `app-store/screenshot-redesign-2026-10-17/index.html`.
Contact sheets: `app-store/screenshot-redesign-2026-10-17/iphone-sequence.png` and `ipad-sequence.png`.
Exports, raw captures, manifest and validation hashes live in the same folder. Renderer/rebuild instructions: `tools/AppStoreScreenshots/`.

## Evidence and validation

Capture source: release commit f7e0587242f382260464ebd0bfbd68e4d104b879; app behavior unchanged. The later production archive changes only app version/build metadata to 2.2 (3). Existing screenshot capture tooling was updated; no feature/test-suite expansion or broad audit.

- Current source built and launched successfully on iPhone 18 Pro Max using XcodeBuildMCP, Release with Swift/C warnings as errors; warnings/errors arrays empty.
- Native XCTest capture runs generated all four iPhone and four iPad screens from the running app. iPhone 18 Pro Max and iPad Pro 13-inch (M5), iOS 27.0 simulators, light appearance, portrait.
- Simulator interactive automation initially failed to apply actions reliably; switched to XCTest. First Release capture attempt needed testability enabled for the existing unit-test target; this was passed only on the capture command. First iPad capture run used a phone-only tab selector; replaced it with the native Units button selector and reran successfully. An initial iPad dark-mode set was rejected during visual QA and recaptured in light appearance.
- Apple-native renderer compiled with warnings as errors. Expected export dimensions: iPhone 1320 × 2868; iPad 2064 × 2752. Opaque, 8-bit RGB PNGs in sRGB; SHA-256 hashes cover final exports and raw inputs.
- Specs checked October 17: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications
- Capture logs/results are in ignored `.build/StoreCaptures-*` paths. Raw attachment manifests are preserved with the proposal evidence.
- Validation checks dimensions, PNG color type/no alpha and hashes. Visual review and gallery interaction verification occur before handoff. This is not a new physical-device or accessibility acceptance claim.

## Next release

The user explicitly requested the same two-part marketing-version convention as the other apps. Verified current Driftly/Pause use 2.2 and Glow uses 2.3. Selected Easy Units version: **2.2**. Published 2.1.1 (2) remains unchanged; new 2.2 (3) is Waiting for Review.

Since 2.1.1 is already public, approval to publish requires a new editable 2.2 version and matching build. Keep app behavior and all other metadata/release settings, reuse existing screenshots/previews until approved replacements are selected, and check live state before release preparation. This release step was explained before approval. After approval, version 2.2 was created and verified 2.2 (3) archived and uploaded. Commit/push only the approved screenshot tooling/assets/docs and required explicitly approved release changes after the update.

Automation remains PAUSED. No scheduling or review-status monitor created.

## Approved publication

Completed both Add for Review and final Submit for Review. App Store Connect submission `961269fc-9eb1-46fd-8f0b-6d6ad7a2a840` shows **Waiting for Review**, **Items Submitted (1)**, exact **2.2 (3)**, October 17 at 8:45 AM PDT. Four iPhone and four iPad screenshots saved in approved order, English (U.S.), with existing inheritance and zero previews retained. Other metadata, What's New and automatic release behavior preserved. Release validation and live evidence: `APP_STORE_2.2_2026-10-17.md` and the gallery's `submission.json`/`evidence/`. Submitted does not mean approved or publicly released.
