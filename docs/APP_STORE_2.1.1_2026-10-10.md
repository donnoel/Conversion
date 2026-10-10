# Easy Units 2.1.1 (2) App Store release

## Target and source

- Selected repository: `/Users/donnoel/Development/Conversion`.
- Platform: iOS/iPadOS; production scheme `Conversion`, configuration `Release`.
- App Store Connect: Easy Units, app `6761770180`, bundle `dn.conversion`.
- Developer team: `H7LG8SK72M`; existing automatic signing.
- Starting source: `d59f12d0af577bc9549dcda75c3fddd1b9c3d39b`, clean `main`, configured remote `github` (`https://github.com/donnoel/Conversion.git`).
- Published baseline: 2.1 (1), uploaded May 28, 2026 at 10:37 AM, verified in App Store Connect. The matching local archive was created at 10:35 AM. Exact baseline Git revision is unrecorded. Since the May 28 icon commit, only the September 16 app icon asset differs in application source; other subsequent changes are guidance and website files.

## Scoped changes

- App Debug/Release marketing version/build: 2.1.1 (2). No independent extensions or Watch app are included.
- Added `Conversion/PrivacyInfo.xcprivacy`: UserDefaults reason `CA92.1` for existing app-local favorites, session state, and Settings version display; no tracking or collected data.
- No application behavior, dependencies, signing configuration, or test suite changes.

## What's New

A refreshed app icon for Easy Units.

## Validation

- Existing 41 unit tests passed on installed iPhone 18 Pro / iOS 27 simulator; zero failures, skips, or runtime warnings. The documented iPhone 17 simulator was unavailable. First attempt could not launch the simulator test host; boot completion and an independent app launch succeeded, then the same tests passed on retry.
- Release archive and App Store distribution export succeeded with Swift/C warnings treated as errors; no warning/error diagnostics in the successful build, test, archive, or export logs.
- Verified actual archive and exported IPA: version 2.1.1, build 2, bundle `dn.conversion`, arm64, iPhone/iPad, minimum iOS 26.0; one app and no embedded extensions.
- Exported app signature passed strict verification. Existing Cloud Managed Apple Distribution certificate and `iOS Team Store Provisioning Profile: dn.conversion` were used. Distribution entitlements include `H7LG8SK72M.dn.conversion`, team `H7LG8SK72M`, and `get-task-allow=false`.
- Privacy manifest in exported app matches source. Automatic version/build management disabled during export/upload.
- 57 tracked and new source input hashes captured before archive; all match final worktree. The scoped release commit must preserve these inputs; the additional release document is not compiled.
- No expanded audit, new tests, physical-device acceptance, or new accessibility claims. The release patch changes version metadata and privacy declaration only.

## App Store Connect

Version 2.1.1 created from the existing version. English (U.S.) localization, description, promotional text, keywords, URLs, copyright, screenshots and previews, review contact/no-sign-in settings, automatic release after approval, immediate updates, and existing ratings preserved. Existing iPhone screenshot assets and three iPad screenshots remain present. App-level privacy, age rating, pricing, and availability untouched.

Upload confirmed successful by Xcode at October 10, 2026, 4:49 PM PDT, with no warning/error diagnostics. Apple processed 2.1.1 (2), and the exact build is assigned to version 2.1.1. Processed build ID `3e9c6451-e1bc-41bc-ae8e-bef85c333567`; live Build Metadata verifies Validated, 2.1.1 (2), `dn.conversion`, team/production entitlements, and iPhone/iPad family. Required encryption answer: None of the algorithms mentioned above, supported by current source and prior build metadata. Both Add for Review and final Submit for Review completed. Live submission detail verified **Waiting for Review**, with exactly one App Version item: iOS App 2.1.1 / 2.1.1 (2). Submitted October 10, 2026 at 4:52 PM PDT by Don Noel. Submission ID `67d24ae6-b399-4881-a94a-b47a5731002b`.

Submission: https://appstoreconnect.apple.com/apps/6761770180/distribution/reviewsubmissions/details/67d24ae6-b399-4881-a94a-b47a5731002b

Submitted is not approved or publicly released; 2.1 remains the published version. No remaining user action. No incidental events, purchases, or assets submitted.

## Evidence

- Archive: `/Users/donnoel/Library/Developer/Xcode/Archives/2026-10-10/Conversion-2.1.1-2.xcarchive`.
- Logs, results, export, IPA validation, source hashes: `/Users/donnoel/.codex/automations/app-app-store-submission/evidence/2026-10-10/Conversion/`.
- Apple's submission workflow: https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-app
- Required reason API reference: https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitype

Automation remains paused. No schedule or review-status monitor enabled.
