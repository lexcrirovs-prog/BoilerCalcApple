import SwiftUI

struct GlossaryButton: View {
    let term: String
    @State private var showPopover = false

    @Environment(\.themeColors) var colors

    var body: some View {
        Button(action: { showPopover.toggle() }) {
            Image(systemName: "info.circle")
                .font(.caption)
                .foregroundColor(colors.primary)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showPopover) {
            VStack(alignment: .leading, spacing: 8) {
                Text(term)
                    .font(.headline)
                if let definition = Glossary.terms[term] {
                    Text(definition)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
            .frame(maxWidth: 300)
            .presentationCompactAdaptation(.popover)
        }
    }
}
