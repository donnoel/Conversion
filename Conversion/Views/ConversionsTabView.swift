import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct ConversionsTabView: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var sessionStateStore: SessionStateStore
    @FocusState private var isInputFocused: Bool

    private var outputDisplayText: String {
        viewModel.outputText == "--" ? "—" : viewModel.outputText
    }

    private var outputAccessibilityLabel: String {
        guard viewModel.outputText != "--" else {
            return "No converted value available. Enter \(viewModel.inputUnit) to convert to \(viewModel.outputUnit)"
        }
        return "Converted result \(viewModel.outputText) \(viewModel.outputUnit), from \(viewModel.inputUnit)"
    }

    var body: some View {
        ZStack {
            LiquidGlassTheme.homeCanvasGradient(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer(minLength: 0)

                Text("\(viewModel.inputUnit) ↔ \(viewModel.outputUnit)")
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.88) : .primary.opacity(0.72))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .accessibilityLabel("Current conversion \(viewModel.inputUnit) to \(viewModel.outputUnit)")

                Text("From \(viewModel.inputUnit)")
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.72) : .secondary)

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

                Text("To \(viewModel.outputUnit)")
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(colorScheme == .dark ? .white.opacity(0.72) : .secondary)

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(outputDisplayText)
                        .font(.system(size: 58, weight: .bold, design: .rounded))
                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.96) : .primary)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .accessibilityIdentifier("converter.output.\(viewModel.selectedPair.id)")

                    Text(viewModel.outputUnit)
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.82) : .secondary)
                        .lineLimit(1)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(outputAccessibilityLabel)

                Spacer(minLength: 0)

                HStack(spacing: 12) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.swapUnits()
                        }
                    } label: {
                        Label("Swap", systemImage: "arrow.left.arrow.right")
                            .font(.system(.subheadline, design: .rounded).weight(.semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.white.opacity(colorScheme == .dark ? 0.16 : 0.62))
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Swap \(viewModel.inputUnit) and \(viewModel.outputUnit)")
                    .accessibilityIdentifier("converter.swap.\(viewModel.selectedPair.id)")

                    Button {
                        sessionStateStore.selectedTab = .units
                    } label: {
                        Label("Units", systemImage: "square.grid.2x2")
                            .font(.system(.subheadline, design: .rounded).weight(.semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.white.opacity(colorScheme == .dark ? 0.16 : 0.62))
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Open units")
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
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

    private func dismissKeyboard() {
        isInputFocused = false
#if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
    }
}

#Preview {
    NavigationStack {
        ConversionsTabView(viewModel: ConversionsViewModel())
            .environmentObject(FavoritesStore())
            .environmentObject(SessionStateStore())
    }
}
