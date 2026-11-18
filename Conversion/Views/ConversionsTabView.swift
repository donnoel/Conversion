import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct ConversionsTabView: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @ObservedObject var toolkitViewModel: ToolkitViewModel

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @EnvironmentObject private var sessionStateStore: SessionStateStore
    @FocusState private var isInputFocused: Bool
    @State private var isShowingPairPicker = false
    @State private var usesPreciseOutput = false
    @State private var copiedOutput: String?
    @ScaledMetric(relativeTo: .largeTitle) private var inputFontSize = 48.0
    @ScaledMetric(relativeTo: .largeTitle) private var outputFontSize = 54.0

    private var outputDisplayText: String {
        guard let outputValue = viewModel.outputValue, outputValue.isFinite else { return "" }
        return usesPreciseOutput ? NumberFormatting.precise(outputValue) : viewModel.outputText
    }

    private var copyText: String? {
        guard !outputDisplayText.isEmpty else { return nil }
        return "\(outputDisplayText) \(viewModel.outputUnit)"
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

            ScrollView {
                converterContent
                    .frame(maxWidth: 480)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
            }
            .defaultScrollAnchor(horizontalSizeClass == .regular ? .center : .top, for: .alignment)
            .scrollDismissesKeyboard(.interactively)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") { dismissKeyboard() }
            }
        }
        .sheet(isPresented: $isShowingPairPicker) {
            PairPickerSheet(
                viewModel: viewModel,
                selectPair: selectPair
            )
            .environmentObject(favoritesStore)
        }
        .onChange(of: copyText) { copiedOutput = nil }
        .task(id: copiedOutput) {
            guard copiedOutput != nil else { return }
            try? await Task.sleep(for: .seconds(2))
            if !Task.isCancelled { copiedOutput = nil }
        }
    }

    private var converterContent: some View {
        VStack(spacing: 16) {
            header
            inputField
            outputContent
            relatedUnitsButton
            shortcutsRow
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
                    dismissKeyboard()
                    isShowingPairPicker = true
                } label: {
                    HStack(spacing: 8) {
                        Text("\(viewModel.inputUnit) to \(viewModel.outputUnit)")
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)
                        Image(systemName: "chevron.down")
                            .font(.footnote.weight(.semibold))
                            .accessibilityHidden(true)
                    }
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 14)
                    .frame(minHeight: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .liquidGlassSurfaceStyle(cornerRadius: 18)
                .accessibilityLabel("Choose conversion pair. Current pair is \(viewModel.inputUnit) to \(viewModel.outputUnit)")
                .accessibilityHint("Opens the unit picker")
                .accessibilityIdentifier("converter.choosePair.\(viewModel.selectedPair.id)")

                Button {
                    withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                        viewModel.swapUnits()
                    }
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.82) : .secondary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Swap \(viewModel.inputUnit) and \(viewModel.outputUnit)")
                .accessibilityHint("Swaps the conversion direction")
                .accessibilityIdentifier("converter.swap.\(viewModel.selectedPair.id)")
            }
        }
    }

    @ViewBuilder
    private var shortcutsRow: some View {
        if !shortcutPairs.isEmpty {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(shortcutPairs) { pair in
                        shortcutButton(for: pair)
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 2)
            }
            .defaultScrollAnchor(.center, for: .alignment)
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
                .frame(minHeight: 44)
                .contentShape(Rectangle())
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
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .liquidGlassSurfaceStyle(cornerRadius: 17)
        .accessibilityLabel("Open \(pair.spokenTitle)")
        .accessibilityIdentifier("converter.shortcut.\(pair.id)")
    }

    private var inputField: some View {
        TextField("Enter value", text: $viewModel.inputText)
            .font(.system(size: inputFontSize, weight: .semibold, design: .rounded).monospacedDigit())
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
            .accessibilityLabel("Input value in \(ConversionCatalog.unitName(for: viewModel.inputUnit))")
            .accessibilityIdentifier("converter.input.\(viewModel.selectedPair.id)")
    }

    @ViewBuilder
    private var outputContent: some View {
        if copyText != nil {
            outputButton
        } else {
            Text(outputStatus)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(minHeight: 44)
        }
    }

    private var outputStatus: String {
        if viewModel.outputValue?.isFinite == false { return "Result is out of range" }
        if NumericInputParser.isIncomplete(viewModel.inputText) { return "Result in \(viewModel.outputUnit)" }
        return "Enter a valid number"
    }

    private var outputButton: some View {
        Button {
            copyOutput()
        } label: {
            VStack(spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(outputDisplayText)
                        .font(.system(size: outputFontSize, weight: .semibold, design: .rounded))
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

                Label(copiedOutput == nil ? "Copy Result" : "Copied", systemImage: copiedOutput == nil ? "doc.on.doc" : "checkmark")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Copy result, \(outputDisplayText) \(ConversionCatalog.unitName(for: viewModel.outputUnit))")
        .accessibilityValue(copiedOutput == nil ? "" : "Copied")
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
            usesPreciseOutput.toggle()
        }
    }

    private func selectPair(_ pair: ConversionPair) {
        viewModel.selectPair(pair)
        usesPreciseOutput = false
    }

    private func openToolkitForCurrentConverter() {
        dismissKeyboard()
        toolkitViewModel.useConverter(
            pair: viewModel.selectedPair,
            inputText: viewModel.inputText,
            isReversed: viewModel.isReversed
        )
        sessionStateStore.selectedTab = .toolkit
    }

    private func copyOutput() {
        guard let copyText else { return }
#if canImport(UIKit)
        UIPasteboard.general.string = copyText
        copiedOutput = copyText
        AccessibilityNotification.Announcement("Result copied").post()
#endif
    }

    private func dismissKeyboard() {
        isInputFocused = false
#if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
    }

    private func shortTitle(for pair: ConversionPair) -> String {
        "\(pair.unitA) ↔ \(pair.unitB)"
    }
}

private struct PairPickerSheet: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @State private var searchText = ""

    let selectPair: (ConversionPair) -> Void

    private var filteredSections: [(category: ConversionCategory, pairs: [ConversionPair])] {
        viewModel.unitPickerSections(matching: searchText)
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
                                        Text(pair.displayTitle)
                                            .font(.system(.body, design: .rounded).weight(.medium))
                                        Text("\(pair.unitA) ↔ \(pair.unitB)")
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
                            .accessibilityLabel("Choose \(pair.spokenTitle)")
                            .accessibilityValue(favoritesStore.isFavorite(pairID: pair.id) ? "Favorite" : "")
                            .accessibilityAddTraits(pair.id == viewModel.selectedPairID ? .isSelected : [])
                            .accessibilityIdentifier("converter.picker.row.\(pair.id)")
                        }
                    }
                }
            }
            .navigationTitle("Choose Units")
            .searchable(text: $searchText, prompt: "Search units")
            .overlay {
                if filteredSections.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
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
