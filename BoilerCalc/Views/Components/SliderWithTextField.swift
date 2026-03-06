import SwiftUI

struct SliderWithTextField: View {
    let label: String
    @Binding var value: Double
    @Binding var textValue: String
    let range: ClosedRange<Double>
    var onSliderChanged: ((Double) -> Void)?
    var onTextChanged: ((String) -> Void)?
    var unitText: String?
    var onUnitClick: (() -> Void)?

    @Environment(\.themeColors) var colors

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(colors.onSurfaceVariant)

            HStack(spacing: 8) {
                Slider(
                    value: Binding(
                        get: { min(max(value, range.lowerBound), range.upperBound) },
                        set: { newVal in
                            value = newVal
                            onSliderChanged?(newVal)
                        }
                    ),
                    in: range
                )
                .tint(colors.primary)

                TextField("", text: Binding(
                    get: { textValue },
                    set: { newText in
                        textValue = newText
                        onTextChanged?(newText)
                    }
                ))
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 90)

                if let unitText = unitText, let onUnitClick = onUnitClick {
                    UnitToggleChip(unitText: unitText, onClick: onUnitClick)
                }
            }
        }
    }
}
