import SwiftUI

struct HeatCalculationView: View {
    @StateObject private var vm = HeatCalcViewModel()

    @Environment(\.themeColors) var colors

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Расчёт тепловой нагрузки")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(colors.onBackground)

                // MARK: - City Selection
                SectionHeader(title: "Населённый пункт")

                SearchableDropdown(
                    query: $vm.cityQuery,
                    items: ClimateDatabase.cities,
                    filteredItems: vm.filteredCities,
                    isExpanded: vm.isCityDropdownExpanded,
                    onQueryChange: { vm.onCityQueryChange($0) },
                    onSelect: { vm.selectCity($0) },
                    onDismiss: { vm.dismissCityDropdown() }
                )

                if let city = vm.selectedCity {
                    VStack(alignment: .leading, spacing: 4) {
                        climateRow(label: "t\u{2099}\u{2080} (расчётная)", value: "\(Int(city.tDesign))\u{00B0}C")
                        climateRow(label: "t\u{2092}\u{2090} (средняя)", value: "\(Formatting.formatTrimmed(city.tHeating, decimals: 1))\u{00B0}C")
                        climateRow(label: "z\u{2092}\u{2090} (дни)", value: "\(city.heatingDays)")
                    }
                    .padding()
                    .background(colors.surfaceVariant)
                    .cornerRadius(12)
                }

                // MARK: - Buildings
                SectionHeader(title: "Здания")

                ForEach(Array(vm.buildings.enumerated()), id: \.element.id) { index, building in
                    BuildingCard(
                        building: binding(for: building),
                        onRemove: vm.buildings.count > 1 ? { vm.removeBuilding(id: building.id) } : nil
                    )
                }

                Button(action: { vm.addBuilding() }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Добавить здание")
                    }
                    .foregroundColor(colors.primary)
                }

                // MARK: - DHW
                SectionHeader(title: "ГВС (горячее водоснабжение)")

                HStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Душевые (\u{00D7}8 кВт)")
                            .font(.caption)
                            .foregroundColor(colors.onSurfaceVariant)
                        Stepper("\(vm.showers)", value: $vm.showers, in: 0...100)
                    }

                    VStack(alignment: .leading) {
                        Text("Умывальники (\u{00D7}1.2 кВт)")
                            .font(.caption)
                            .foregroundColor(colors.onSurfaceVariant)
                        Stepper("\(vm.sinks)", value: $vm.sinks, in: 0...100)
                    }
                }

                // MARK: - Calculate button
                Button(action: { vm.calculate() }) {
                    Text("Рассчитать")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vm.selectedCity != nil ? colors.primary : colors.surfaceVariant)
                        .foregroundColor(vm.selectedCity != nil ? colors.onPrimary : colors.onSurfaceVariant)
                        .cornerRadius(12)
                }
                .disabled(vm.selectedCity == nil)

                // MARK: - Results
                if vm.isCalculated {
                    SectionHeader(title: "Результаты")

                    VStack(alignment: .leading, spacing: 8) {
                        ResultRow(label: "Q\u{2092}\u{2090} (отопление)", value: "\(Formatting.formatTrimmed(vm.qHeating, decimals: 1)) кВт")
                        ResultRow(label: "Q\u{0433}\u{0432}\u{0441}", value: "\(Formatting.formatTrimmed(vm.qDHW, decimals: 1)) кВт")
                        Divider()
                        ResultRow(label: "Q\u{2092}\u{0431}\u{0449} (итого)", value: "\(Formatting.formatTrimmed(vm.qTotal, decimals: 1)) кВт")
                        ResultRow(label: "Q\u{0433}\u{043E}\u{0434} (годовое)", value: "\(Formatting.formatTrimmed(vm.annualHeat, decimals: 1)) МВт\u{00B7}ч/год")
                        ResultRow(label: "ГСОП", value: "\(Formatting.formatTrimmed(vm.gsop, decimals: 0)) \u{00B0}C\u{00B7}сут")
                    }
                    .padding()
                    .background(colors.surfaceVariant)
                    .cornerRadius(12)

                    if !vm.selectedBoilers.isEmpty {
                        SectionHeader(title: "Подбор котлов")

                        ForEach(vm.selectedBoilers) { boiler in
                            WaterBoilerCard(boiler: boiler)
                        }
                    }
                }
            }
            .padding()
        }
        .background(colors.background)
    }

    private func binding(for building: Building) -> Binding<Building> {
        Binding(
            get: { building },
            set: { vm.updateBuilding(id: building.id, building: $0) }
        )
    }

    @ViewBuilder
    private func climateRow(label: String, value: String) -> some View {
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

// MARK: - Building Card

struct BuildingCard: View {
    @Binding var building: Building
    var onRemove: (() -> Void)?

    @Environment(\.themeColors) var colors

    private let buildingTypes = ["Производственное", "Складское", "Административное", "Жилое"]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Здание #\(building.id)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(colors.onSurface)
                Spacer()
                if let onRemove = onRemove {
                    Button(action: onRemove) {
                        Image(systemName: "trash")
                            .foregroundColor(colors.error)
                    }
                    .buttonStyle(.plain)
                }
            }

            Picker("Тип", selection: $building.type) {
                ForEach(buildingTypes, id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(.menu)

            Toggle("Ручной ввод объёма", isOn: $building.useManualVolume)

            if building.useManualVolume {
                HStack {
                    Text("Объём (м\u{00B3})")
                        .font(.caption)
                    TextField("", value: $building.volume, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                }
            } else {
                HStack(spacing: 8) {
                    dimField(label: "Ш (м)", value: $building.width)
                    dimField(label: "Д (м)", value: $building.length)
                    dimField(label: "В (м)", value: $building.height)
                }
            }

            HStack {
                Text("q\u{2080} (Вт/м\u{00B3}\u{00B7}\u{00B0}C)")
                    .font(.caption)
                    .foregroundColor(colors.onSurfaceVariant)
                TextField("", value: $building.q0, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
            }
        }
        .padding()
        .background(colors.surfaceVariant)
        .cornerRadius(12)
    }

    @ViewBuilder
    private func dimField(label: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption2)
                .foregroundColor(colors.onSurfaceVariant)
            TextField("", value: value, format: .number)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
        }
    }
}
