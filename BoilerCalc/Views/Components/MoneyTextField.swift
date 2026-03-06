import SwiftUI

struct MoneyTextField: View {
    let label: String
    @Binding var text: String
    var suffix: String = "руб"
    var onChanged: ((String) -> Void)?

    @Environment(\.themeColors) var colors

    var body: some View {
        HStack {
            TextField(label, text: Binding(
                get: { text },
                set: { newText in
                    text = newText
                    onChanged?(newText)
                }
            ))
            .keyboardType(.decimalPad)
            .textFieldStyle(.roundedBorder)

            Text(suffix)
                .font(.subheadline)
                .foregroundColor(colors.onSurfaceVariant)
        }
    }
}
