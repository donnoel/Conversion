import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct ToolkitTabView: View {
    @StateObject private var viewModel = ToolkitViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isInputFocused: Bool

    var body: some View {
        ZStack {
            LiquidGlassTheme.gentleCanvasGradient(for: colorScheme)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: LiquidGlassTheme.sectionSpacing) {
                    headerCard
                    controlsCard
                    outputsCard
                }
                .frame(maxWidth: LiquidGlassTheme.contentWidth, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .scrollDismissesKeyboard(.immediately)
        }
        .navigationTitle("Toolkit")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    dismissKeyboard()
                }
            }
        }
        .simultaneousGesture(
            TapGesture().onEnded {
                dismissKeyboard()
            }
        )
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Multi-Convert")
                .font(.system(.title2, design: .rounded).weight(.semibold))
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.95) : .primary)

            Text("Enter one value and see related units update instantly.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.74) : .secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .liquidGlassCardStyle()
        .accessibilityIdentifier("toolkit.header")
    }

    private var controlsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Category")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)

                Picker("Category", selection: $viewModel.selectedCategory) {
                    ForEach(viewModel.categories) { category in
                        Text(category.title).tag(category)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityIdentifier("toolkit.category")
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("From Unit")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)

                Picker("From Unit", selection: $viewModel.sourceUnitSymbol) {
                    ForEach(viewModel.availableUnitSymbols, id: \.self) { symbol in
                        Text("\(viewModel.unitDisplayName(for: symbol)) (\(symbol))")
                            .tag(symbol)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityIdentifier("toolkit.source")
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Input")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)

                TextField("Enter value", text: $viewModel.inputText)
                    .font(.system(.title2, design: .rounded).weight(.semibold).monospacedDigit())
                    .keyboardType(.numbersAndPunctuation)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($isInputFocused)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: LiquidGlassTheme.controlCornerRadius, style: .continuous)
                            .fill(Color.white.opacity(colorScheme == .dark ? 0.11 : 0.66))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: LiquidGlassTheme.controlCornerRadius, style: .continuous)
                            .strokeBorder(Color.white.opacity(colorScheme == .dark ? 0.16 : 0.46), lineWidth: 0.7)
                    )
                    .accessibilityLabel("Toolkit input in \(viewModel.sourceUnitSymbol)")
                    .accessibilityIdentifier("toolkit.input")
            }
        }
        .padding(LiquidGlassTheme.cardPadding)
        .liquidGlassCardStyle()
    }

    private var outputsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Outputs")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.92) : .primary)

            if viewModel.conversionResults.isEmpty {
                Text("No available outputs for this category.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.conversionResults) { result in
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(result.unitName.capitalized)
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .foregroundStyle(.primary)

                            Text(result.unitSymbol)
                                .font(.system(.caption, design: .rounded).weight(.medium))
                                .foregroundStyle(.secondary)
                        }

                        Spacer(minLength: 8)

                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text(result.outputText)
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.95) : .primary)
                                .monospacedDigit()

                            Text(result.unitSymbol)
                                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white.opacity(colorScheme == .dark ? 0.08 : 0.46))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(Color.white.opacity(colorScheme == .dark ? 0.14 : 0.38), lineWidth: 0.6)
                    )
                    .accessibilityIdentifier("toolkit.output.\(result.unitSymbol)")
                }
            }
        }
        .padding(LiquidGlassTheme.cardPadding)
        .liquidGlassCardStyle()
        .accessibilityIdentifier("toolkit.outputs")
    }

    private func dismissKeyboard() {
        isInputFocused = false
#if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
    }
}

#Preview {
    NavigationStack {
        ToolkitTabView()
    }
}
