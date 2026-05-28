import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct ConversionsTabView: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @ObservedObject var toolkitViewModel: ToolkitViewModel

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @EnvironmentObject private var sessionStateStore: SessionStateStore
    @FocusState private var isInputFocused: Bool
    @State private var isShowingPairPicker = false
    @State private var usesPreciseOutput = false

    private var outputDisplayText: String {
        guard let outputValue = viewModel.outputValue else { return "" }
        return usesPreciseOutput ? NumberFormatting.precise(outputValue) : viewModel.outputText
    }

    private var outputAccessibilityLabel: String {
        guard viewModel.outputValue != nil else {
            return "No converted value available. Enter \(viewModel.inputUnit) to convert to \(viewModel.outputUnit)"
        }
        return "Converted result \(outputDisplayText) \(viewModel.outputUnit), from \(viewModel.inputUnit)"
    }

    private var favoritePairs: [ConversionPair] {
        viewModel.allPairs
            .filter { favoritesStore.isFavorite(pairID: $0.id) }
            .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    private var recentPairs: [ConversionPair] {
        sessionStateStore.recentPairIDs.compactMap(ConversionCatalog.pair(withID:))
    }

    private var shortcutPairs: [ConversionPair] {
        var seenIDs: Set<String> = []
        return (favoritePairs + recentPairs)
            .filter { pair in
                guard pair.id != viewModel.selectedPairID, !seenIDs.contains(pair.id) else {
                    return false
                }
                seenIDs.insert(pair.id)
                return true
            }
            .prefix(5)
            .map { $0 }
    }

    var body: some View {
        ZStack {
            LiquidGlassTheme.homeCanvasGradient(for: colorScheme)
                .ignoresSafeArea()

            Group {
                if horizontalSizeClass == .regular {
                    VStack(spacing: 0) {
                        converterContent
                    }
                    .frame(maxWidth: 520)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 24)
                } else {
                    VStack(spacing: 0) {
                        converterContent
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $isShowingPairPicker) {
            PairPickerSheet(
                viewModel: viewModel,
                selectPair: selectPair
            )
            .environmentObject(favoritesStore)
        }
        .simultaneousGesture(
            TapGesture().onEnded {
                dismissKeyboard()
            }
        )
    }

    private var converterContent: some View {
        VStack(spacing: 0) {
            header

            shortcutsRow
                .padding(.top, 18)

            Spacer(minLength: 30)

            VStack(spacing: 18) {
                inputField
                outputButton
            }

            Spacer(minLength: 0)
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Text("Conversion")
                .font(.system(.caption, design: .rounded).weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.72) : .secondary)

            HStack(spacing: 8) {
                Button {
                    isShowingPairPicker = true
                } label: {
                    Text("\(viewModel.inputUnit) to \(viewModel.outputUnit)")
                        .font(.system(.title2, design: .rounded).weight(.semibold))
                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.95) : .primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Choose conversion pair. Current pair is \(viewModel.inputUnit) to \(viewModel.outputUnit)")
                .accessibilityHint("Opens the unit picker")
                .accessibilityIdentifier("converter.choosePair.\(viewModel.selectedPair.id)")

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.swapUnits()
                    }
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.82) : .secondary)
                        .frame(width: 34, height: 34)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Swap \(viewModel.inputUnit) and \(viewModel.outputUnit)")
                .accessibilityHint("Swaps the conversion direction")
                .accessibilityIdentifier("converter.swap.\(viewModel.selectedPair.id)")
            }
        }
        .padding(.top, 16)
    }

    private var shortcutsRow: some View {
        Group {
            if shortcutPairs.isEmpty {
                relatedUnitsButton
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(shortcutPairs) { pair in
                            shortcutButton(for: pair)
                        }

                        relatedUnitsButton
                    }
                    .padding(.horizontal, 2)
                    .padding(.vertical, 2)
                }
            }
        }
    }

    private var relatedUnitsButton: some View {
        Button {
            openToolkitForCurrentConverter()
        } label: {
            Label("Related Units", systemImage: "square.grid.3x3")
                .font(.system(.caption, design: .rounded).weight(.semibold))
                .labelStyle(.titleAndIcon)
                .padding(.horizontal, 12)
                .frame(height: 34)
        }
        .buttonStyle(.plain)
        .liquidGlassSurfaceStyle(cornerRadius: 17)
        .accessibilityLabel("View all related units")
        .accessibilityHint("Opens Toolkit with the current converter input")
        .accessibilityIdentifier("converter.openToolkit")
    }

    private func shortcutButton(for pair: ConversionPair) -> some View {
        Button {
            selectPair(pair)
        } label: {
            Text(shortTitle(for: pair))
                .font(.system(.caption, design: .rounded).weight(.semibold))
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.92) : .primary)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .frame(height: 34)
        }
        .buttonStyle(.plain)
        .liquidGlassSurfaceStyle(cornerRadius: 17)
        .accessibilityLabel("Open \(displayTitle(for: pair))")
        .accessibilityIdentifier("converter.shortcut.\(pair.id)")
    }

    private var inputField: some View {
        TextField("Enter value", text: $viewModel.inputText)
            .font(.system(size: 52, weight: .semibold, design: .rounded).monospacedDigit())
            .foregroundStyle(colorScheme == .dark ? .white : .primary)
            .multilineTextAlignment(.center)
            .keyboardType(.numbersAndPunctuation)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($isInputFocused)
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.white.opacity(colorScheme == .dark ? 0.18 : 0.64))
            )
            .overlay(
                Capsule(style: .continuous)
                    .strokeBorder(Color.white.opacity(colorScheme == .dark ? 0.18 : 0.48), lineWidth: 0.7)
            )
            .frame(maxWidth: 380)
            .accessibilityLabel("Input value in \(viewModel.inputUnit)")
            .accessibilityIdentifier("converter.input.\(viewModel.selectedPair.id)")
    }

    private var outputButton: some View {
        Button {
            copyOutput()
        } label: {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(outputDisplayText)
                    .font(.system(size: 58, weight: .semibold, design: .rounded))
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.96) : .primary)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)
                    .accessibilityIdentifier("converter.output.\(viewModel.selectedPair.id)")

                Text(viewModel.outputUnit)
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.82) : .secondary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.outputValue == nil)
        .accessibilityLabel(outputAccessibilityLabel)
        .accessibilityHint(viewModel.outputValue == nil ? "" : "Copies the converted result")
        .accessibilityIdentifier("converter.output.copy")
        .contextMenu {
            Button {
                copyOutput()
            } label: {
                Label("Copy Result", systemImage: "doc.on.doc")
            }

            Button {
                usesPreciseOutput.toggle()
            } label: {
                Label(
                    usesPreciseOutput ? "Show Rounded Result" : "Show More Precision",
                    systemImage: "number"
                )
            }
        }
        .onLongPressGesture {
            guard viewModel.outputValue != nil else { return }
            usesPreciseOutput.toggle()
        }
    }

    private func selectPair(_ pair: ConversionPair) {
        viewModel.selectPair(pair)
        usesPreciseOutput = false
    }

    private func openToolkitForCurrentConverter() {
        toolkitViewModel.useConverter(
            pair: viewModel.selectedPair,
            inputText: viewModel.inputText,
            isReversed: viewModel.isReversed
        )
        sessionStateStore.selectedTab = .toolkit
    }

    private func copyOutput() {
        guard !outputDisplayText.isEmpty else { return }
#if canImport(UIKit)
        UIPasteboard.general.string = "\(outputDisplayText) \(viewModel.outputUnit)"
#endif
    }

    private func dismissKeyboard() {
        isInputFocused = false
#if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
    }

    private func displayTitle(for pair: ConversionPair) -> String {
        "\(fullUnitName(for: pair.unitA)) <-> \(fullUnitName(for: pair.unitB))"
    }

    private func shortTitle(for pair: ConversionPair) -> String {
        "\(pair.unitA) <-> \(pair.unitB)"
    }

    private func fullUnitName(for symbol: String) -> String {
        switch symbol {
        case "cm": "centimeters"
        case "in": "inches"
        case "kg": "kilograms"
        case "lb": "pounds"
        case "c": "celsius"
        case "f": "fahrenheit"
        case "K": "kelvin"
        case "mm": "millimeters"
        case "m": "meters"
        case "ft": "feet"
        case "km": "kilometers"
        case "mi": "miles"
        case "g": "grams"
        case "oz": "ounces"
        case "L": "liters"
        case "pt": "pints"
        case "qt": "quarts"
        case "gal": "gallons"
        case "tsp": "teaspoons"
        case "tbsp": "tablespoons"
        case "mph": "miles per hour"
        case "kph": "kilometers per hour"
        case "m/s": "meters per second"
        case "psi": "pounds per square inch"
        case "bar": "bar"
        case "kPa": "kilopascals"
        case "ac": "acres"
        case "ha": "hectares"
        case "sq ft": "square feet"
        case "sq m": "square meters"
        case "rad": "radians"
        case "deg": "degrees"
        case "hp": "horsepower"
        case "kw": "kilowatts"
        case "yd": "yards"
        case "mL": "milliliters"
        case "fl oz": "fluid ounces"
        case "cup": "cups"
        case "sec": "seconds"
        case "min": "minutes"
        case "hr": "hours"
        case "day": "days"
        case "KB": "kilobytes"
        case "MB": "megabytes"
        case "GB": "gigabytes"
        case "TB": "terabytes"
        case "mpg": "miles per gallon"
        case "L/100km": "liters per 100 kilometers"
        case "km/L": "kilometers per liter"
        case "J": "joules"
        case "cal": "calories"
        case "kcal": "kilocalories"
        case "Wh": "watt-hours"
        case "kWh": "kilowatt-hours"
        case "Nm": "newton-meters"
        case "lb-ft": "pound-feet"
        case "in-lb": "inch-pounds"
        default: symbol
        }
    }
}

private struct PairPickerSheet: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @State private var searchText = ""

    let selectPair: (ConversionPair) -> Void

    private var filteredSections: [(category: ConversionCategory, pairs: [ConversionPair])] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        return viewModel.unitPickerSections.compactMap { section in
            let pairs = section.pairs.filter { pair in
                guard !query.isEmpty else { return true }
                return pair.title.lowercased().contains(query)
                    || pair.unitA.lowercased().contains(query)
                    || pair.unitB.lowercased().contains(query)
                    || section.category.title.lowercased().contains(query)
            }
            guard !pairs.isEmpty else { return nil }
            return (section.category, pairs)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredSections, id: \.category) { section in
                    Section(section.category.title) {
                        ForEach(section.pairs) { pair in
                            Button {
                                selectPair(pair)
                                dismiss()
                            } label: {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(pair.title)
                                            .font(.system(.body, design: .rounded).weight(.medium))
                                        Text("\(pair.unitA) <-> \(pair.unitB)")
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    if favoritesStore.isFavorite(pairID: pair.id) {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(LiquidGlassTheme.favoriteTint)
                                            .accessibilityHidden(true)
                                    }

                                    if pair.id == viewModel.selectedPairID {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(LiquidGlassTheme.tint)
                                            .accessibilityHidden(true)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Choose \(pair.title)")
                            .accessibilityIdentifier("converter.picker.row.\(pair.id)")
                        }
                    }
                }
            }
            .navigationTitle("Choose Units")
            .searchable(text: $searchText, prompt: "Search units")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.large])
    }
}

#Preview {
    NavigationStack {
        ConversionsTabView(
            viewModel: ConversionsViewModel(),
            toolkitViewModel: ToolkitViewModel()
        )
        .environmentObject(FavoritesStore())
        .environmentObject(SessionStateStore())
    }
}
