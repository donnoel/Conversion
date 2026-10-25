# AGENTS.project.md

# Conversion Project Guide for Agents

## Product intent
Conversion is a personal-use Apple-platform utility app focused on fast, elegant, and trustworthy unit conversion.
- Serves: one user on iPhone and iPad who wants common conversions without friction.
- Problem solved: quick inline conversion with zero drill-in for core tasks.
- Success criteria: conversions are immediate, readable, reversible, and favorites are one tap away.

## Current product phase (Phase 1 implemented)
Current scope is Phase 1.
1) MVP scope
- Home-first focused converter surface
- Units tab with category sections and lightweight search
- Toolkit tab for one-input multi-convert within a selected category
- Inline reversible conversion with clear from/to units
- Favorites surfaced at the top of Units and managed there
- Local-only persistence
- Last-session state restoration for tab/search, last-used pair, and per-pair direction state (input clears on relaunch)

2) Architecture boundaries
- SwiftUI + MVVM
- Conversion logic in models/view models
- Persistence isolated in service/store
- No third-party dependencies

3) Reliability and UX goals
- Zero build warnings
- Stable keyboard/input behavior during typing
- Deterministic conversion rules from one catalog source
- Conversion results display at most 3 fractional digits for readability

4) Testing priorities
- Conversion rule coverage and reversibility
- Temperature formula correctness
- Numeric input parsing and output formatting behavior
- Toolkit unit exposure/order for newly added symbols

## Architecture snapshot (current)
- App entry and navigation model
  - `ConversionApp` -> `ContentView` -> `RootTabView`
  - Tab-based structure: `Conversion`, `Units`, `Toolkit`
- Core view models/services
  - `ConversionsViewModel` for selected pair, search, input/swap/output state, and session restore hooks
  - `ToolkitViewModel` for category/source-unit selection and one-input multi-convert outputs
  - `ConverterCardViewModel` remains used by favorites card rendering
  - `FavoritesStore` (`@MainActor`) with `FavoritesPersistenceService` actor for persistence
  - `SessionStateStore` (`@MainActor`) for lightweight local browsing/converter session restore
- Data flow and persistence
  - `ConversionCatalog` is the single source of truth for supported conversion pairs
  - Favorites persisted in `UserDefaults` (`favoriteConversionPairIDs.v1`)

## Concurrency rules (important)
- Keep SwiftUI/UI state on main actor (`ViewModel` + UI-facing store)
- Keep persistence IO in actor-backed service (`FavoritesPersistenceService`)
- Do not use broad `@MainActor` on models/services as a shortcut

## Behavior invariants (do not regress)
- Every supported pair is reversible inline via swap control.
- Conversions update immediately as the user types.
- Favorites toggle instantly and persist locally across launches.
- Users can pick any supported pair quickly from the unit-picker sheet.
- The `kph <-> mph` pair opens as `kph -> mph` by default.
- Supported conversion catalog now contains 54 reversible pairs across 14 categories.
- Pair-first expansion rule: add new support by extending `ConversionCatalog` within existing categories so `Units` and `Toolkit` derive availability automatically.

## UX rules
- No forced detail navigation for basic conversion.
- Keep the home converter readable and stable while editing.
- Use clear unit labels and concise output formatting.
- Keep interactions subtle and touch-targets comfortable.

## Coding conventions
- Keep files small and focused.
- Prefer explicit conversion rules over ad-hoc math in views.
- Use Apple-native frameworks only.

## Build/run notes
- Platforms: iPhone + iPad (`TARGETED_DEVICE_FAMILY = 1,2`)
- Swift language mode: 6.0 (Swift 6.2 toolchain)
- Warning policy: zero warnings
- Local unit tests command:
  - `xcodebuild -scheme Conversion -project Conversion.xcodeproj -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:ConversionTests -skip-testing:ConversionUITests test`

## Near-term priorities
- Add focused UI tests for key inline conversion and favorites flows.
- Improve card-level accessibility copy and VoiceOver polish.
- Consider optional per-card input history/reset controls (if needed).

## Supported pairs snapshot
- Length: `cm <-> inches`, `meters <-> centimeters`, `mm <-> inches`, `meters <-> feet`, `km <-> miles`, `miles <-> feet`, `cm <-> feet`, `inches <-> feet`, `meters <-> yards`
- Weight / Mass: `kg <-> lbs`, `kg <-> grams`, `lb <-> grams`, `grams <-> ounces`, `pounds <-> ounces`
- Temperature: `celsius <-> fahrenheit`, `celsius <-> kelvin`
- Volume: `tsp <-> mL`, `tbsp <-> mL`, `liters <-> gallons`, `pt <-> L`, `qt <-> L`, `mL <-> cups`, `fl oz <-> mL`
- Cooking Volume: `cups <-> tablespoons`, `cups <-> teaspoons`, `cups <-> pints`, `gallons <-> quarts`
- Speed: `kph <-> mph`, `kph <-> m/s`, `mph <-> m/s`
- Pressure: `psi <-> bar`, `psi <-> kPa`, `bar <-> kPa`
- Area: `acres <-> hectares`, `acres <-> square feet`, `square feet <-> square meters`
- Angle: `radians <-> degrees`
- Power: `hp <-> kw`
- Time: `seconds <-> minutes`, `minutes <-> hours`, `hours <-> days`
- Data: `KB <-> MB`, `MB <-> GB`, `GB <-> TB`
- Fuel Economy: `mpg <-> L/100km`, `mpg <-> km/L`, `L/100km <-> km/L`
- Energy: `joules <-> calories`, `calories <-> kilocalories`, `Wh <-> kWh`, `kilocalories <-> kWh`
- Torque: `Nm <-> lb-ft`, `lb-ft <-> in-lb`, `Nm <-> in-lb`

## Output expectations per patch
Provide:
- Summary of change
- Files modified
- Any migration considerations
- Commit message suggestion

## CI reliability and local validation

- For ordinary changes, start with the narrowest relevant build, unit test or UI check. Expand for shared behavior, persistence, startup or release risk. Documentation and local tool-selection helper changes need scoped structural/contract checks; they do not require an application rebuild solely to repeat CI.
- Use `bash scripts/local-check.sh <command> [args...]` for local checks. It selects already-installed Xcode 26.6 for that command without changing global defaults, and preserves an explicit `DEVELOPER_DIR`. If unavailable, focused commands can use the existing compiler with the difference reported; the strict CI driver still rejects a mismatch.
- GitHub keeps Xcode 26.6 and Simulator 26.5. For deliberate complete reproduction use `bash scripts/local-check.sh bash scripts/ci.sh all <fresh-iOS-26.5-simulator-UDID>`. Fresh simulators are for isolated/full reproduction; preserve existing simulator data. Upgrade pinned baselines in a separate validated change.
- Run the complete affected suites when changing build/test workflow behavior, test harnesses or shared fixtures, or when reproducing a hosted failure. Full local CI is not a blanket prerequisite for every edit. Keep GitHub CI enabled and all existing suites/assertions; a focused pass is not a full-suite pass.
- Check installed tools and equivalent capabilities before proposing a download. Do not install or switch global tools merely to obtain exact CI parity for an unrelated change. Report local compiler/runtime/browser/OS differences and checks not run; only observed GitHub results establish hosted CI success.
- Keep the build, unit-test, and UI-test phases and all existing assertions. Build/test workflow, harness and shared-fixture changes require complete affected-suite evidence.
- Use explicit calendars/timezones for date fixtures, deterministic verified text replacement and readiness conditions for UI, and isolated cloud/Keychain fixtures where those services are not being tested. Repair a failing assumption across related tests rather than retrying or disabling it.
- Classify zero-step payment/spending-limit failures as unavailable execution evidence, separately from compilation, assertions, and deployment. Inspect annotations before editing code for an account block.
- Documentation-only pushes skip expensive CI; optional pull-request checks remain present. Superseded same-ref runs are cancelled. Change pinned compiler/runtime versions deliberately and validate the complete suite.
