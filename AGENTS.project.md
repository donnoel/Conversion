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
- Category-first conversion browsing
- Focused single-category browsing with lightweight search
- Inline reversible converter cards
- Favorites tab with persisted favorites
- Local-only persistence

2) Architecture boundaries
- SwiftUI + MVVM
- Conversion logic in models/view models
- Persistence isolated in service/store
- No third-party dependencies

3) Reliability and UX goals
- Zero build warnings
- Stable keyboard/input behavior during typing
- Deterministic conversion rules from one catalog source

4) Testing priorities
- Conversion rule coverage and reversibility
- Temperature formula correctness
- Numeric input parsing and output formatting behavior

## Architecture snapshot (current)
- App entry and navigation model
  - `ConversionApp` -> `ContentView` -> `RootTabView`
  - Tab-based structure: `Conversions`, `Favorites`
- Core view models/services
  - `ConversionsViewModel` for selected-category + search-driven pair presentation
  - `ConverterCardViewModel` for card input/swap/output state
  - `FavoritesStore` (`@MainActor`) with `FavoritesPersistenceService` actor for persistence
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
- Categories remain the primary browsing structure.

## UX rules
- No forced detail navigation for basic conversion.
- Keep converter cards readable and stable while editing.
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

## Output expectations per patch
Provide:
- Summary of change
- Files modified
- Any migration considerations
- Commit message suggestion
