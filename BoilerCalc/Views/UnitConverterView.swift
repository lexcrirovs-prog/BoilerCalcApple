import SwiftUI

struct UnitConverterView: View {
    @StateObject private var vm = ConverterViewModel()

    @Environment(\.themeColors) var colors

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Конвертер единиц")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(colors.onBackground)

                // MARK: - Group selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(UnitDefinitions.groups.enumerated()), id: \.offset) { index, group in
                            Button(action: { vm.selectGroup(index) }) {
                                Text(group.name)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(index == vm.selectedGroupIndex ? colors.primary : colors.surfaceVariant)
                                    .foregroundColor(index == vm.selectedGroupIndex ? colors.onPrimary : colors.onSurfaceVariant)
                                    .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // MARK: - From/To unit pickers + swap
                HStack(spacing: 8) {
                    VStack(alignment: .leading) {
                        Text("Из")
                            .font(.caption)
                            .foregroundColor(colors.onSurfaceVariant)
                        Picker("", selection: $vm.fromUnitIndex) {
                            ForEach(Array(vm.currentGroup.units.enumerated()), id: \.offset) { index, unit in
                                Text(unit.name).tag(index)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(colors.primary)
                    }

                    Button(action: { vm.swapUnits() }) {
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.title3)
                            .foregroundColor(colors.primary)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 16)

                    VStack(alignment: .leading) {
                        Text("В")
                            .font(.caption)
                            .foregroundColor(colors.onSurfaceVariant)
                        Picker("", selection: $vm.toUnitIndex) {
                            ForEach(Array(vm.currentGroup.units.enumerated()), id: \.offset) { index, unit in
                                Text(unit.name).tag(index)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(colors.primary)
                    }
                }

                // MARK: - Input
                TextField("Значение", text: Binding(
                    get: { vm.inputText },
                    set: { vm.onInputChange($0) }
                ))
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .font(.title3)

                // MARK: - Result
                VStack(alignment: .leading, spacing: 4) {
                    Text("Результат")
                        .font(.caption)
                        .foregroundColor(colors.onSurfaceVariant)

                    HStack(alignment: .firstTextBaseline) {
                        Text(vm.resultText)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(colors.primary)
                        Text(vm.currentGroup.units[vm.toUnitIndex].name)
                            .font(.subheadline)
                            .foregroundColor(colors.onSurfaceVariant)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(colors.surfaceVariant)
                .cornerRadius(12)

                // MARK: - Presets
                if let presets = ConverterPresets.presets[vm.selectedGroupIndex], !presets.isEmpty {
                    SectionHeader(title: "Быстрые конвертации")

                    FlowLayout(spacing: 8) {
                        ForEach(Array(presets.enumerated()), id: \.offset) { _, preset in
                            Button(action: { vm.applyPreset(fromName: preset.0, toName: preset.1) }) {
                                Text("\(preset.0) \u{2192} \(preset.1)")
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(colors.surfaceVariant)
                                    .foregroundColor(colors.onSurfaceVariant)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .background(colors.background)
    }
}

// MARK: - FlowLayout for presets
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }

        return (CGSize(width: maxX, height: y + rowHeight), positions)
    }
}
