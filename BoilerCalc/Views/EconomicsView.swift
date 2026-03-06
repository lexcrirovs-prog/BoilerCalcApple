import SwiftUI

struct EconomicsView: View {
    @StateObject private var vm = EconomicsViewModel()
    @State private var showLeadForm = false

    @Environment(\.themeColors) var colors

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Экономика котельной")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(colors.onBackground)

                // MARK: - Boiler Selection
                SectionHeader(title: "Выбор котла")

                // Category selector
                HStack(spacing: 0) {
                    categoryButton("Паровой", tag: "steam")
                    categoryButton("Водогр. C", tag: "water")
                    categoryButton("Водогр. E", tag: "waterE")
                }
                .cornerRadius(8)

                // Model dropdown
                let models = vm.getModelsForCategory(vm.boilerCategory)
                if !models.isEmpty {
                    Picker("Модель котла", selection: Binding(
                        get: { vm.selectedModel?.id ?? "" },
                        set: { id in
                            if let model = models.first(where: { $0.id == id }) {
                                vm.selectModel(model)
                            }
                        }
                    )) {
                        Text("Выберите модель").tag("")
                        ForEach(models) { model in
                            Text("\(model.name) — \(Formatting.formatMoney(Double(model.price)))")
                                .tag(model.id)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(colors.primary)
                }

                // Boiler count
                if vm.selectedModel != nil {
                    Stepper("Количество: \(vm.boilerCount)", value: $vm.boilerCount, in: 1...20, step: 1) { _ in
                        vm.onBoilerCountChange(vm.boilerCount)
                    }

                    // Economizer (only for steam with economizerPrice)
                    if let model = vm.selectedModel, model.economizerPrice != nil {
                        Toggle("Экономайзер (+\(Formatting.formatMoney(Double(model.economizerPrice!)))/шт)", isOn: Binding(
                            get: { vm.useEconomizer },
                            set: { vm.onUseEconomizerChange($0) }
                        ))
                    }

                    // CAPEX card
                    HStack {
                        HStack(spacing: 4) {
                            Text("CAPEX")
                                .fontWeight(.semibold)
                            GlossaryButton(term: "CAPEX")
                        }
                        Spacer()
                        Text(Formatting.formatMoney(vm.capex))
                            .fontWeight(.bold)
                            .foregroundColor(colors.primary)
                    }
                    .padding()
                    .background(colors.surfaceVariant)
                    .cornerRadius(12)
                }

                // MARK: - OPEX
                if vm.selectedModel != nil {
                    HStack(spacing: 4) {
                        SectionHeader(title: "OPEX")
                        GlossaryButton(term: "OPEX")
                    }

                    Group {
                        inputField(label: "Загрузка (%)", text: $vm.loadText, onChange: { vm.onLoadChange($0) })
                        inputField(label: "Часов в сутки", text: $vm.dailyHoursText, onChange: { vm.onDailyHoursChange($0) })
                        inputField(label: "Рабочих дней/год", text: $vm.workDaysText, onChange: { vm.onWorkDaysChange($0) })
                        inputField(label: "Цена газа (руб/м\u{00B3})", text: $vm.gasPriceText, onChange: { vm.onGasPriceChange($0) })
                        MoneyTextField(label: "Обслуживание (руб/год)", text: $vm.maintenanceCostText, onChanged: { vm.onMaintenanceChange($0) })
                    }

                    // OPEX results card
                    VStack(alignment: .leading, spacing: 6) {
                        ResultRow(label: "Годовой расход газа", value: "\(Formatting.formatNumber(vm.annualGas, decimals: 0)) м\u{00B3}")
                        ResultRow(label: "Годовой выход тепла", value: "\(Formatting.formatTrimmed(vm.annualHeatGcal, decimals: 1)) Гкал")
                        Divider()
                        ResultRow(label: "OPEX (годовой)", value: Formatting.formatMoney(vm.annualOPEX))
                    }
                    .padding()
                    .background(colors.surfaceVariant)
                    .cornerRadius(12)

                    // MARK: - Revenue
                    SectionHeader(title: "Доходы")

                    inputField(label: "Тариф (руб/Гкал)", text: $vm.tarifGcalText, onChange: { vm.onTarifGcalChange($0) })

                    // Revenue mode toggle
                    Picker("Режим доходов", selection: Binding(
                        get: { vm.revenueMode },
                        set: { vm.onRevenueModeChange($0) }
                    )) {
                        Text("Равномерный").tag("uniform")
                        Text("По годам").tag("variable")
                    }
                    .pickerStyle(.segmented)

                    if vm.revenueMode == "uniform" {
                        MoneyTextField(label: "Годовой доход", text: $vm.uniformRevenueText, onChanged: { vm.onUniformRevenueChange($0) })
                    } else {
                        ForEach(0..<vm.yearsCount, id: \.self) { year in
                            HStack {
                                Text("Год \(year + 1)")
                                    .font(.caption)
                                    .frame(width: 50)
                                TextField("Доход", text: Binding(
                                    get: { Formatting.formatNumber(vm.variableRevenues[year], decimals: 0) },
                                    set: { vm.onVariableRevenueChange(year: year, text: $0) }
                                ))
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                            }
                        }
                    }

                    HStack {
                        Text("Лет расчёта: \(vm.yearsCount)")
                        Stepper("", value: Binding(
                            get: { vm.yearsCount },
                            set: { vm.onYearsCountChange($0) }
                        ), in: 1...30)
                    }

                    inputField(label: "Ставка дисконтирования (%)", text: $vm.discountRateText, onChange: { vm.onDiscountRateChange($0) })

                    // MARK: - Calculate button
                    Button(action: { vm.calculate() }) {
                        Text("Рассчитать окупаемость")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(colors.primary)
                            .foregroundColor(colors.onPrimary)
                            .cornerRadius(12)
                    }

                    // MARK: - Results
                    if vm.isCalculated, let result = vm.paybackResult {
                        SectionHeader(title: "Результаты")

                        HStack(spacing: 12) {
                            paybackCard(title: "PP", subtitle: "Простая окупаемость", value: result.pp, term: "PP")
                            paybackCard(title: "DPBP", subtitle: "Дисконт. окупаемость", value: result.dpbp, term: "DPBP")
                        }

                        // Payback table
                        SectionHeader(title: "Денежные потоки")

                        ScrollView(.horizontal, showsIndicators: true) {
                            VStack(spacing: 0) {
                                // Header
                                HStack(spacing: 0) {
                                    econTableCell("Год", isHeader: true, width: 40)
                                    econTableCell("Доход", isHeader: true)
                                    econTableCell("CF", isHeader: true)
                                    econTableCell("\u{2211}CF", isHeader: true)
                                    econTableCell("PV", isHeader: true)
                                    econTableCell("\u{2211}PV", isHeader: true)
                                }
                                .background(colors.primaryContainer)

                                ForEach(result.table) { row in
                                    HStack(spacing: 0) {
                                        econTableCell("\(row.year)", width: 40)
                                        econTableCell(Formatting.formatNumber(row.revenue, decimals: 0))
                                        econTableCell(Formatting.formatNumber(row.cashFlow, decimals: 0))
                                        econTableCell(Formatting.formatNumber(row.cumCashFlow, decimals: 0))
                                        econTableCell(Formatting.formatNumber(row.presentValue, decimals: 0))
                                        econTableCell(Formatting.formatNumber(row.cumPresentValue, decimals: 0))
                                    }
                                    Divider()
                                }
                            }
                        }
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(colors.outline, lineWidth: 1))

                        // Lead form button
                        Button(action: { showLeadForm = true }) {
                            Text("Получить скидку")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(colors.tertiary)
                                .foregroundColor(colors.onTertiary)
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .padding()
        }
        .background(colors.background)
        .sheet(isPresented: $showLeadForm) {
            LeadFormSheet(
                title: "Получить скидку",
                context: "Экономика: \(vm.selectedModel?.name ?? "")",
                onDismiss: { showLeadForm = false }
            )
        }
    }

    // MARK: - Helpers

    @ViewBuilder
    private func categoryButton(_ title: String, tag: String) -> some View {
        Button(action: { vm.selectCategory(tag) }) {
            Text(title)
                .font(.subheadline)
                .fontWeight(vm.boilerCategory == tag ? .bold : .regular)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(vm.boilerCategory == tag ? colors.primary : colors.surfaceVariant)
                .foregroundColor(vm.boilerCategory == tag ? colors.onPrimary : colors.onSurfaceVariant)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func inputField(label: String, text: Binding<String>, onChange: @escaping (String) -> Void) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(colors.onSurfaceVariant)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("", text: Binding(
                get: { text.wrappedValue },
                set: { newVal in
                    text.wrappedValue = newVal
                    onChange(newVal)
                }
            ))
            .keyboardType(.decimalPad)
            .textFieldStyle(.roundedBorder)
            .frame(width: 100)
        }
    }

    @ViewBuilder
    private func paybackCard(title: String, subtitle: String, value: Double, term: String) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(colors.primary)
                GlossaryButton(term: term)
            }
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(colors.onSurfaceVariant)
            Text(formatPayback(value))
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(colors.onSurface)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(colors.surfaceVariant)
        .cornerRadius(12)
    }

    @ViewBuilder
    private func econTableCell(_ text: String, isHeader: Bool = false, width: CGFloat = 80) -> some View {
        Text(text)
            .font(.system(size: 10))
            .fontWeight(isHeader ? .bold : .regular)
            .foregroundColor(isHeader ? colors.onPrimaryContainer : colors.onSurface)
            .frame(width: width)
            .padding(.vertical, 4)
    }

    private func formatPayback(_ value: Double) -> String {
        if value < 0 { return ">\(vm.yearsCount) лет" }
        let years = Int(value)
        let months = Int((value - Double(years)) * 12)
        return "\(years) г. \(months) мес."
    }
}
