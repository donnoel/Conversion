# Conversion

A polished Apple-native unit conversion app for iPhone and iPad, built with SwiftUI + MVVM.

## Phase 1 features
- Category-first conversion browsing
- Inline converter cards (no forced detail navigation)
- Reversible conversion direction per card
- Favorites tab with one-tap favorite toggles
- Local persistence of favorites
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
- `ConversionRule` encapsulates linear and affine formulas.
- `ConverterCardViewModel` handles per-card input, swap state, and output.
- `FavoritesStore` + `FavoritesPersistenceService` handle local favorites persistence.

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
