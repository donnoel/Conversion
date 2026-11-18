import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct ConversionsTabView: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @ObservedObject var toolkitViewModel: ToolkitViewModel

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @EnvironmentObject private var sessionStateStore: SessionStateStore
    @FocusState private var isInputFocused: Bool
    @State private var isShowingPairPicker = false
    @State private var usesPreciseOutput = false
    @State private var copiedOutput: String?
    @ScaledMetric(relativeTo: .largeTitle) private var valueFontSize: CGFloat = 42
    @ScaledMetric(relativeTo: .largeTitle) private var valueLineHeight: CGFloat = 56
    @ScaledMetric(relativeTo: .caption) private var shortcutWidth: CGFloat = 82

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

            GeometryReader { viewport in
                ScrollView {
                    converterContent
                        .frame(maxWidth: 560)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        // Leave more space below the panel while letting compact layouts scroll.
                        .frame(maxWidth: .infinity, minHeight: viewport.size.height * 0.82)
                }
                .scrollDismissesKeyboard(.interactively)
            }
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
            VStack(spacing: 12) {
                pairPickerButton

                VStack(spacing: 5) {
                    valuePanel("From", unit: viewModel.inputUnit, isFocused: isInputFocused) {
                        inputField
                    }

                    swapControl

                    outputPanel
                }

                let actionsLayout = dynamicTypeSize.isAccessibilitySize
                    ? AnyLayout(VStackLayout(spacing: 8))
                    : AnyLayout(HStackLayout(spacing: 8))
                actionsLayout {
                    copyResultButton
                    relatedUnitsButton
                }
            }
            .padding(16)
            .liquidGlassCardStyle()

            shortcutsRow
        }
    }

    private var pairPickerButton: some View {
        Button {
            dismissKeyboard()
            isShowingPairPicker = true
        } label: {
            HStack(spacing: 8) {
                Text("\(viewModel.inputUnit) to \(viewModel.outputUnit)")
                    .font(.system(.title2, design: .rounded).weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)

                Image(systemName: "chevron.down")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Choose conversion pair. Current pair is \(viewModel.inputUnit) to \(viewModel.outputUnit)")
        .accessibilityHint("Opens the unit picker")
        .accessibilityIdentifier("converter.choosePair.\(viewModel.selectedPair.id)")
    }

    private var swapControl: some View {
        HStack(spacing: 12) {
            Rectangle().fill(Color(uiColor: .separator)).frame(height: 1)
                .accessibilityHidden(true)

            Button {
                withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                    viewModel.swapUnits()
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(LiquidGlassTheme.tint)
                    .frame(width: 44, height: 44)
                    .background(LiquidGlassTheme.tint.opacity(colorScheme == .dark ? 0.20 : 0.10), in: Circle())
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Swap \(viewModel.inputUnit) and \(viewModel.outputUnit)")
            .accessibilityHint("Swaps the conversion direction")
            .accessibilityIdentifier("converter.swap.\(viewModel.selectedPair.id)")

            Rectangle().fill(Color(uiColor: .separator)).frame(height: 1)
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 12)
    }

    private func valuePanel<Content: View>(
        _ title: String,
        unit: String,
        isFocused: Bool = false,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 2) {
            Text("\(title) · \(unit)")
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .accessibilityHidden(true)

            content()
                .frame(maxWidth: .infinity, minHeight: valueLineHeight)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            Color(uiColor: .secondarySystemGroupedBackground).opacity(reduceTransparency ? 1 : 0.84),
            in: RoundedRectangle(cornerRadius: 18)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(isFocused ? LiquidGlassTheme.tint : Color.primary.opacity(0.10), lineWidth: 1)
                .allowsHitTesting(false)
        }
    }

    private var valueFont: Font {
        .system(size: valueFontSize, weight: .semibold, design: .rounded).monospacedDigit()
    }

    @ViewBuilder
    private var shortcutsRow: some View {
        let pairs = shortcutPairs
        if !pairs.isEmpty {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(pairs) { pair in
                        shortcutButton(for: pair, count: pairs.count)
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
            actionLabel("Related Units", icon: "square.grid.3x3")
        }
        .buttonStyle(.plain)
        .accessibilityLabel("View all related units")
        .accessibilityHint("Opens Toolkit with the current converter input")
        .accessibilityIdentifier("converter.openToolkit")
    }

    private func shortcutButton(for pair: ConversionPair, count: Int) -> some View {
        Button {
            selectPair(pair)
        } label: {
            Text(shortTitle(for: pair))
                .font(.system(.caption, design: .rounded).weight(.semibold))
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.92) : .primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 5)
                .frame(maxWidth: .infinity, minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .containerRelativeFrame(.horizontal) { width, _ in
            let spacing = CGFloat(count - 1) * 8 + 4
            return min(shortcutWidth, max(shortcutWidth * 0.78, (width - spacing) / CGFloat(count)))
        }
        .liquidGlassSurfaceStyle(cornerRadius: 17)
        .accessibilityLabel("Open \(pair.spokenTitle)")
        .accessibilityIdentifier("converter.shortcut.\(pair.id)")
    }

    private var inputField: some View {
        TextField(
            "Enter value",
            text: $viewModel.inputText,
            prompt: Text("Enter value").font(.system(.title3, design: .rounded).weight(.medium))
        )
        .font(valueFont)
        .multilineTextAlignment(.center)
        .keyboardType(.numbersAndPunctuation)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .focused($isInputFocused)
        .accessibilityLabel("Input value in \(ConversionCatalog.unitName(for: viewModel.inputUnit))")
        .accessibilityIdentifier("converter.input.\(viewModel.selectedPair.id)")
    }

    private var outputPanel: some View {
        valuePanel("To", unit: viewModel.outputUnit) {
            if copyText != nil {
                Text(outputDisplayText)
                    .font(valueFont)
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)
                    .accessibilityIdentifier("converter.output.\(viewModel.selectedPair.id)")
            } else if viewModel.outputValue?.isFinite == false {
                outputMessage("Result is out of range")
            } else if NumericInputParser.isIncomplete(viewModel.inputText) {
                Text("—")
                    .font(.system(.title3, design: .rounded).weight(.medium))
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Result in \(ConversionCatalog.unitName(for: viewModel.outputUnit))")
            } else {
                outputMessage("Enter a valid number")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: copyOutput)
        .contextMenu {
            if copyText != nil {
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
        }
        .onLongPressGesture {
            if copyText != nil { usesPreciseOutput.toggle() }
        }
    }

    private func outputMessage(_ message: String) -> some View {
        Text(message)
            .font(.callout)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var copyResultButton: some View {
        Button(action: copyOutput) {
            actionLabel(copiedOutput == nil ? "Copy Result" : "Copied", icon: copiedOutput == nil ? "doc.on.doc" : "checkmark")
                .opacity(copyText == nil ? 0.55 : 1)
        }
        .buttonStyle(.plain)
        .disabled(copyText == nil)
        .accessibilityLabel(copyText == nil
            ? "Copy Result"
            : "Copy result, \(outputDisplayText) \(ConversionCatalog.unitName(for: viewModel.outputUnit))")
        .accessibilityValue(copiedOutput == nil ? "" : "Copied")
        .accessibilityIdentifier("converter.output.copy")
    }

    private func actionLabel(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.system(.footnote, design: .rounded).weight(.semibold))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(LiquidGlassTheme.tint.opacity(colorScheme == .dark ? 0.18 : 0.08), in: RoundedRectangle(cornerRadius: 14))
            .contentShape(Rectangle())
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
