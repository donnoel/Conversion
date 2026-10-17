# Easy Units 2.2 (3) — October 17, 2026

Status: **Submitted — Waiting for Review**, exact 2.2 (3), one app item, October 17, 2026 at 8:45 AM PDT.

The user approved all eight screenshot exports in the local gallery, requested the same two-part marketing-version convention as the other apps, and explicitly authorized submission, commit and push. The live 2.1.1 (2) app was Ready for Distribution with no pending editable version or 2.2 build. A new 2.2 version and matching 2.2 (3) binary were therefore required. There was no pending submission to cancel.

- App: Easy Units, ASC 6761770180, dn.conversion, team H7LG8SK72M.
- Platform: iPhone/iPad; Conversion scheme, production Release configuration.
- Only app/project change: Debug/Release marketing version 2.1.1 → 2.2, build 2 → 3. No app behavior or signing configuration changed.
- The screenshot capture test/tooling, eight approved exports, raw captures, gallery, contact sheets, captions, approval/hashes, and evidence are scoped release work.
- Production archive and distribution export succeeded with no warning/error diagnostics; Swift/C warnings treated as errors.
- All 41 existing unit tests passed on iPhone 18 Pro Max / iOS 27.0, with zero failures/skips/runtime warnings.
- Actual archive and IPA: 2.2 (3), dn.conversion, arm64, iPhone/iPad, minimum iOS 26.0, no embedded extensions. Strict signature validation passed; privacy manifest matches source.
- Existing Cloud Managed Apple Distribution and iOS Team Store Provisioning Profile: dn.conversion used. Production entitlements: H7LG8SK72M.dn.conversion, team H7LG8SK72M, get-task-allow=false, beta-reports-active=true. Automatic version/build management disabled.
- Xcode confirmed upload succeeded October 17 at 8:35 AM PDT. Apple processed exact 2.2 (3); attached and verified in the final review submission.
- New version copied existing English (U.S.) metadata, review contact/no-sign-in settings, automatic release after approval, immediate updates and retained ratings. Existing What's New preserved exactly: `A refreshed app icon for Easy Units.` Privacy, age rating, pricing, availability, URLs, description, keywords and promotional text untouched.
- All eight approved screenshots were uploaded and verified in order. The old associations were removed from the new version only; assets remain in the Asset Library. No duplicate upload/version/submission was attempted. No signing/tool reconfiguration or dependency installation performed.

Archive: `/Users/donnoel/Library/Developer/Xcode/Archives/2026-10-17/Conversion-2.2-3.xcarchive`.
Logs, IPA verification and source snapshot: `/Users/donnoel/.codex/automations/app-app-store-submission/evidence/2026-10-17/Conversion/`.
Approved assets: `docs/app-store/screenshot-redesign-2026-10-17/`; source/approval/manifest/validation JSON files preserve provenance and reviewed bytes.

No new physical-device acceptance claim. Automation remains paused; no scheduling or review-status monitor created.

## Submission evidence

https://appstoreconnect.apple.com/apps/6761770180/distribution/reviewsubmissions/details/961269fc-9eb1-46fd-8f0b-6d6ad7a2a840

Final live detail: **Waiting for Review**, **Items Submitted (1)**, **iOS App 2.2 / 2.2 (3)**, October 17 at 8:45 AM PDT, submitted by Don Noel. No incidental event/purchase/asset submissions. Existing public 2.1.1 (2) remains distinct from this submitted update.

Four English (U.S.) iPhone 1320×2868 screenshots and four iPad 2064×2752 screenshots replaced only this version's old associations. Old assets remain in Apple's Asset Library. Verified filename order 01-convert, 02-toolkit, 03-favorites, 04-choose; required iPhone medium view inherits large master; iPad smaller sizes/localizations inherit 13-inch master. Existing previews remain zero. All other metadata, What's New, contact/no-sign-in details, automatic release, immediate updates and ratings were preserved.

The unresponsive Go to Folder sheet was resolved by using the native chooser's column navigation; no tool installation, signing changes, or authentication bypass. The alternate in-app browser login was not used.

Live screenshots/AX snapshots, archive source SHA-256 snapshot, IPA verification and unit-test summary are preserved in `docs/app-store/screenshot-redesign-2026-10-17/evidence/`; exact submission data is in `submission.json`.

## Publication scope

The release commit includes only required version/build metadata, the existing screenshot capture workflow, native renderer/validator, approved assets with provenance/hashes, gallery/contact sheets, and release documentation. Branch `main`, configured remote `github` (`https://github.com/donnoel/Conversion.git`). The immutable archive snapshot contains 58 tracked-file hashes; these must match both release commit blobs and final worktree. Git publication verification is retained with the external release evidence and reported at handoff.
