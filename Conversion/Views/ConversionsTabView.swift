import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct ConversionsTabView: View {
    @ObservedObject var viewModel: ConversionsViewModel
    @Environment(\.colorScheme) private var colorScheme
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

            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    Text("Conversion")
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.72) : .secondary)

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.swapUnits()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Text("\(viewModel.inputUnit) to \(viewModel.outputUnit)")
                                .font(.system(.title2, design: .rounded).weight(.bold))
                                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.95) : .primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)

                            Image(systemName: "arrow.left.arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.82) : .secondary)
                                .accessibilityHidden(true)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Swap \(viewModel.inputUnit) and \(viewModel.outputUnit)")
                    .accessibilityHint("Swaps the conversion direction")
                    .accessibilityIdentifier("converter.swap.\(viewModel.selectedPair.id)")
                }
                .padding(.top, 16)

                Spacer(minLength: 30)

                VStack(spacing: 18) {
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

                }

                Spacer(minLength: 0)
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
