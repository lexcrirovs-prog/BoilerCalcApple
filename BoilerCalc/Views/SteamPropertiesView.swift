import SwiftUI

struct SteamPropertiesView: View {
    @StateObject private var vm = SteamViewModel()
    @State private var showLeadForm = false

    @Environment(\.themeColors) var colors

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Свойства насыщенного пара")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(colors.onBackground)

                // MARK: - Steam Parameters
                SectionHeader(title: "Параметры пара")

                SliderWithTextField(
                    label: "Давление",
                    value: vm.pressureSliderBinding,
                    textValue: $vm.pressureText,
                    range: vm.pressureSliderRange,
                    onSliderChanged: { vm.onPressureSliderChange($0) },
                    onTextChanged: { vm.onPressureChange($0) },
                    unitText: vm.pressureUnit,
                    onUnitClick: { vm.togglePressureUnit() }
                )

                SliderWithTextField(
                    label: "Температура",
                    value: vm.temperatureSliderBinding,
                    textValue: $vm.temperatureText,
                    range: vm.temperatureSliderRange,
                    onSliderChanged: { vm.onTemperatureSliderChange($0) },
                    onTextChanged: { vm.onTemperatureChange($0) },
                    unitText: vm.tempUnit,
                    onUnitClick: { vm.toggleTempUnit() }
                )

                SliderWithTextField(
                    label: "Паропроизводительность",
                    value: vm.capacitySliderBinding,
                    textValue: $vm.steamCapacityText,
                    range: vm.capacitySliderRange,
                    onSliderChanged: { vm.onSteamCapacitySliderChange($0) },
                    onTextChanged: { vm.onSteamCapacityChange($0) },
                    unitText: vm.capacityUnit,
                    onUnitClick: { vm.toggleCapacityUnit() }
                )

                // MARK: - Fuel Characteristics
                SectionHeader(title: "Характеристики топлива")

                HStack {
                    VStack(alignment: .leading) {
                        Text("Q\u{2099} (ккал/м\u{00B3})")
                            .font(.caption)
                            .foregroundColor(colors.onSurfaceVariant)
                        TextField("", text: Binding(
                            get: { vm.calorificText },
                            set: { vm.onCalorificChange($0) }
                        ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading) {
                        Text("КПД (%)")
                            .font(.caption)
                            .foregroundColor(colors.onSurfaceVariant)
                        TextField("", text: Binding(
                            get: { vm.efficiencyText },
                            set: { vm.onEfficiencyChange($0) }
                        ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                    }
                }

                // MARK: - Results
                if let props = vm.steamProps {
                    SectionHeader(title: "Результаты")

                    VStack(spacing: 8) {
                        resultCard(title: "Свойства пара") {
                            ResultRow(label: "h' (энтальпия воды)", value: "\(Formatting.formatTrimmed(props.hPrime, decimals: 1)) кДж/кг")
                            ResultRow(label: "h'' (энтальпия пара)", value: "\(Formatting.formatTrimmed(props.hDoublePrime, decimals: 1)) кДж/кг")
                            ResultRow(label: "r (скрытая теплота)", value: "\(Formatting.formatTrimmed(props.latentHeat, decimals: 1)) кДж/кг")
                            ResultRow(label: "v (уд. объём)", value: "\(Formatting.formatTrimmed(props.specificVolume, decimals: 3)) м\u{00B3}/кг")
                        }

                        resultCard(title: "Мощность и расход газа") {
                            HStack {
                                Text("Мощность")
                                    .foregroundColor(colors.onSurfaceVariant)
                                Spacer()
                                Text("\(vm.displayPower()) \(vm.powerUnit)")
                                    .fontWeight(.semibold)
                                UnitToggleChip(unitText: vm.powerUnit, onClick: { vm.togglePowerUnit() })
                            }
                            ResultRow(label: "Расход газа", value: "\(Formatting.formatTrimmed(vm.gasConsumption, decimals: 1)) м\u{00B3}/ч")
                        }
                    }
                }

                // MARK: - Boiler Selection
                if !vm.selectedBoilers.isEmpty {
                    SectionHeader(title: "Подбор котлов")

                    ForEach(vm.selectedBoilers) { boiler in
                        SteamBoilerCard(boiler: boiler)
                    }
                }

                // MARK: - Steam Table
                SectionHeader(title: "Паровая таблица")

                steamTableView()

                // MARK: - Lead Form Button
                Button(action: { showLeadForm = true }) {
                    Text("Получить предложение")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(colors.primary)
                        .foregroundColor(colors.onPrimary)
                        .cornerRadius(12)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .background(colors.background)
        .sheet(isPresented: $showLeadForm) {
            LeadFormSheet(
                title: "Получить предложение",
                context: "Пар: \(vm.displayPressure()) \(vm.pressureUnit), \(vm.displayCapacity()) \(vm.capacityUnit)",
                onDismiss: { showLeadForm = false }
            )
        }
    }

    @ViewBuilder
    private func resultCard(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(colors.onSurface)
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colors.surfaceVariant)
        .cornerRadius(12)
    }

    @ViewBuilder
    private func steamTableView() -> some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 0) {
                tableCell("P бар", isHeader: true)
                tableCell("t \u{00B0}C", isHeader: true)
                tableCell("h'", isHeader: true)
                tableCell("h''", isHeader: true)
                tableCell("r", isHeader: true)
                tableCell("v", isHeader: true)
            }
            .background(colors.primaryContainer)

            ForEach(Array(SteamTable.entries.enumerated()), id: \.offset) { _, entry in
                HStack(spacing: 0) {
                    tableCell(Formatting.formatTrimmed(entry.pressureGauge, decimals: 1))
                    tableCell(Formatting.formatTrimmed(entry.temperature, decimals: 1))
                    tableCell(Formatting.formatTrimmed(entry.hPrime, decimals: 1))
                    tableCell(Formatting.formatTrimmed(entry.hDoublePrime, decimals: 1))
                    tableCell(Formatting.formatTrimmed(entry.latentHeat, decimals: 1))
                    tableCell(Formatting.formatTrimmed(entry.specificVolume, decimals: 3))
                }
                .background(colors.surface)
                Divider()
            }
        }
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(colors.outline, lineWidth: 1))
    }

    @ViewBuilder
    private func tableCell(_ text: String, isHeader: Bool = false) -> some View {
        Text(text)
            .font(.system(size: 10))
            .fontWeight(isHeader ? .bold : .regular)
            .foregroundColor(isHeader ? colors.onPrimaryContainer : colors.onSurface)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .padding(.horizontal, 2)
    }
}

struct ResultRow: View {
    let label: String
    let value: String

    @Environment(\.themeColors) var colors

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(colors.onSurfaceVariant)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(colors.onSurface)
        }
    }
}
