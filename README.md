# **Easy Units**

### *Everyday conversions. Clear answers. Less friction.*

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange?logo=swift&logoColor=white" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/UI-SwiftUI-blue?logo=apple&logoColor=white" alt="SwiftUI">
  <img src="https://img.shields.io/badge/Platforms-iPhone_|_iPad-0A84FF?logo=apple&logoColor=white" alt="iPhone and iPad">
  <img src="https://img.shields.io/badge/iOS-26.0%2B-5E5CE6" alt="iOS 26.0+">
  <img src="https://img.shields.io/badge/Architecture-MVVM-8E8E93" alt="MVVM">
  <img src="https://img.shields.io/badge/Categories-9-34C759" alt="9 categories">
  <img src="https://img.shields.io/badge/Pairs-34-A2845E" alt="34 conversion pairs">
</p>

---

## ✨ Overview

A polished Apple-native unit conversion app for iPhone and iPad, built with SwiftUI + MVVM.

## 💎 Core Features

| Feature | What it does |
| --- | --- |
| **Focused conversion** | Convert values with reversible directions and instant results. |
| **Unit browser** | Search categories and keep favorite units close at hand. |
| **Toolkit** | Compare one input against multiple units in a category. |
| **Session restoration** | Restore navigation and preferences while clearing the input on relaunch. |

<details>
<summary>Feature details and controls</summary>

<a id="phase-1-features"></a>

### Phase 1 features

- Friendly home converter with one focused conversion surface
- Dedicated `Units` tab with search and category sections
- Dedicated `Toolkit` tab for one-input, many-output conversion within a chosen category
- Favorite units shown at the top of the `Units` tab for quick switching
- Reversible conversion direction inline
- Favorite toggles available in the Units list
- Local persistence of favorites
- Last-session state restoration (tab, last used pair, search, per-pair swap direction)
- Converter input value is cleared when the app relaunches
- Instant conversion updates while typing
- Clean numeric output formatting capped at 3 fractional digits
- iOS/iPadOS Settings app entry shows dynamic app `Version (Build)`

<a id="supported-conversion-pairs-reversible"></a>

### Supported conversion pairs (reversible)

- `cm <-> inches`
- `meters <-> centimeters`
- `kg <-> lbs`
- `kg <-> grams`
- `celsius <-> fahrenheit`
- `celsius <-> kelvin`
- `mm <-> inches`
- `meters <-> feet`
- `km <-> miles`
- `miles <-> feet`
- `cm <-> feet`
- `lb <-> grams`
- `grams <-> ounces`
- `inches <-> feet`
- `tsp <-> mL`
- `tbsp <-> mL`
- `liters <-> gallons`
- `pt <-> L`
- `qt <-> L`
- `pounds <-> ounces`
- `kph <-> mph` (defaults to `kph -> mph` when opened)
- `kph <-> m/s`
- `mph <-> m/s`
- `psi <-> bar`
- `psi <-> kPa`
- `bar <-> kPa`
- `acres <-> hectares`
- `acres <-> square feet`
- `square feet <-> square meters`
- `radians <-> degrees`
- `hp <-> kw`
- `meters <-> yards`
- `mL <-> cups`
- `fl oz <-> mL`

</details>

---

## 🚀 Getting Started

<a id="build-and-test"></a>

### Build and test

Build:
```bash
xcodebuild -scheme Conversion -project Conversion.xcodeproj -destination 'generic/platform=iOS Simulator' build
```

Run unit tests:
```bash
xcodebuild -scheme Conversion -project Conversion.xcodeproj -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:ConversionTests -skip-testing:ConversionUITests test
```

## 🧠 How It Works

<a id="architecture"></a>

### Architecture

- `ConversionCatalog` is the single source of truth for supported converters.
- `ConversionRule` is backed by Foundation `Measurement` / `Unit` conversions.
- `ConversionsViewModel` handles selected pair, input, swap state, search, and output.
- `ToolkitViewModel` handles category/source-unit selection and multi-output conversion rows.
- `FavoritesStore` + `FavoritesPersistenceService` handle local favorites persistence.
- `SessionStateStore` restores tab/search state plus last-used pair and per-pair session state.

<a id="project-structure"></a>

### Project structure

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

## 🔒 Data and Privacy

Favorites and last-session preferences are persisted locally. The conversion input is deliberately cleared on relaunch; restored navigation does not restore the previous value.

## 📚 Documentation

- [Repository guidance](AGENTS.md)
- [Project guide](AGENTS.project.md)

---

## 🤝 Credits

<a id="credits"></a>

Built with care by **Don Noel** and Codex collaboration.
