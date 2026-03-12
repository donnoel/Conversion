# Conversion

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange?logo=swift&logoColor=white" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/UI-SwiftUI-blue?logo=apple&logoColor=white" alt="SwiftUI">
  <img src="https://img.shields.io/badge/Platforms-iPhone_|_iPad-0A84FF?logo=apple&logoColor=white" alt="iPhone and iPad">
  <img src="https://img.shields.io/badge/iOS-26.0%2B-5E5CE6" alt="iOS 26.0+">
  <img src="https://img.shields.io/badge/Architecture-MVVM-8E8E93" alt="MVVM">
  <img src="https://img.shields.io/badge/Categories-8-34C759" alt="8 categories">
  <img src="https://img.shields.io/badge/Pairs-17-A2845E" alt="17 conversion pairs">
</p>

A polished Apple-native unit conversion app for iPhone and iPad, built with SwiftUI + MVVM.

## Phase 1 features
- Friendly home converter with one focused conversion surface
- Dedicated `Units` tab with search and category sections
- Favorite units shown at the top of Home for quick one-tap switching
- Reversible conversion direction inline
- Favorite toggles available on Home and Units list
- Local persistence of favorites
- Last-session state restoration (tab, last used pair, search, per-pair input/swap state)
- Instant conversion updates while typing
- Clean numeric output formatting

## Supported conversion pairs (reversible)
- `cm <-> inches`
- `kg <-> lbs`
- `Celsius <-> Fahrenheit`
- `mm <-> inches`
- `meters <-> feet`
- `km <-> miles`
- `cm <-> feet`
- `grams <-> ounces`
- `inches <-> feet`
- `liters <-> gallons`
- `pounds <-> ounces`
- `mph <-> kph`
- `acres <-> square feet`
- `radians <-> degrees`
- `hp <-> kw`
- `meters <-> yards`
- `mL <-> cups`

## Architecture
- `ConversionCatalog` is the single source of truth for supported converters.
- `ConversionRule` is backed by Foundation `Measurement` / `Unit` conversions.
- `ConversionsViewModel` handles selected pair, input, swap state, search, and output.
- `FavoritesStore` + `FavoritesPersistenceService` handle local favorites persistence.
- `SessionStateStore` restores tab/search state plus last-used pair and per-pair session state.

## Build and test
Build:
```bash
xcodebuild -scheme Conversion -project Conversion.xcodeproj -destination 'generic/platform=iOS Simulator' build
```

Run unit tests:
```bash
xcodebuild -scheme Conversion -project Conversion.xcodeproj -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:ConversionTests -skip-testing:ConversionUITests test
```

## Project structure
```text
Conversion/
├── Models/
├── Stores/
├── Utilities/
├── ViewModels/
├── Views/
├── ConversionApp.swift
└── ContentView.swift
```
