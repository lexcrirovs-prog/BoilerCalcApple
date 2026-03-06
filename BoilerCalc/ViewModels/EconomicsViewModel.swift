import Foundation
import Combine

class EconomicsViewModel: ObservableObject {
    // Boiler selection
    @Published var boilerCategory: String = "steam"  // steam | water | waterE
    @Published var selectedModel: EconBoilerModel?
    @Published var boilerCount: Int = 1
    @Published var useEconomizer: Bool = false

    // OPEX params
    @Published var loadPercent: Double = 0.75
    @Published var loadText: String = "75"
    @Published var dailyHours: Double = 24.0
    @Published var dailyHoursText: String = "24"
    @Published var workDays: Int = 350
    @Published var workDaysText: String = "350"
    @Published var gasPrice: Double = 8.0
    @Published var gasPriceText: String = "8"
    @Published var maintenanceCost: Double = 300000.0
    @Published var maintenanceCostText: String = "300 000"

    // OPEX results
    @Published var annualGas: Double = 0.0
    @Published var annualOPEX: Double = 0.0
    @Published var annualHeatGcal: Double = 0.0

    // CAPEX
    @Published var capex: Double = 0.0

    // Tariff
    @Published var tarifGcal: Double = 0.0
    @Published var tarifGcalText: String = ""

    // Revenue
    @Published var revenueMode: String = "uniform"  // uniform | variable
    @Published var uniformRevenue: Double = 0.0
    @Published var uniformRevenueText: String = ""
    @Published var variableRevenues: [Double] = Array(repeating: 0.0, count: 10)
    @Published var yearsCount: Int = 10
    @Published var discountRate: Double = 0.10
    @Published var discountRateText: String = "10"

    // Results
    @Published var paybackResult: PaybackResult?
    @Published var isCalculated: Bool = false

    func getModelsForCategory(_ category: String) -> [EconBoilerModel] {
        switch category {
        case "steam": return EconBoilerDatabase.steam
        case "water": return EconBoilerDatabase.water
        case "waterE": return EconBoilerDatabase.waterE
        default: return []
        }
    }

    func selectCategory(_ category: String) {
        boilerCategory = category
        selectedModel = nil
        useEconomizer = false
        capex = 0.0
        isCalculated = false
    }

    func selectModel(_ model: EconBoilerModel) {
        selectedModel = model
        capex = calculateCapex(model: model, count: boilerCount, useEconomizer: useEconomizer)
        isCalculated = false
        recalculateOPEX()
    }

    func onBoilerCountChange(_ count: Int) {
        boilerCount = min(max(count, 1), 20)
        if let model = selectedModel {
            capex = calculateCapex(model: model, count: boilerCount, useEconomizer: useEconomizer)
        }
        isCalculated = false
        recalculateOPEX()
    }

    func onUseEconomizerChange(_ enabled: Bool) {
        useEconomizer = enabled
        if let model = selectedModel {
            capex = calculateCapex(model: model, count: boilerCount, useEconomizer: enabled)
        }
        isCalculated = false
    }

    func onLoadChange(_ text: String) {
        loadText = text
        if let value = Double(text.replacingOccurrences(of: ",", with: ".")) {
            loadPercent = value / 100.0
            recalculateOPEX()
        }
        isCalculated = false
    }

    func onDailyHoursChange(_ text: String) {
        dailyHoursText = text
        if let value = Double(text.replacingOccurrences(of: ",", with: ".")) {
            dailyHours = min(max(value, 0.0), 24.0)
            recalculateOPEX()
        }
        isCalculated = false
    }

    func onWorkDaysChange(_ text: String) {
        workDaysText = text
        if let value = Int(text) {
            workDays = min(max(value, 0), 366)
            recalculateOPEX()
        }
        isCalculated = false
    }

    func onGasPriceChange(_ text: String) {
        gasPriceText = text
        if let value = Double(text.replacingOccurrences(of: ",", with: ".")) {
            gasPrice = value
            recalculateOPEX()
        }
        isCalculated = false
    }

    func onMaintenanceChange(_ text: String) {
        maintenanceCostText = text
        maintenanceCost = Formatting.parseMoney(text)
        recalculateOPEX()
        isCalculated = false
    }

    func onRevenueModeChange(_ mode: String) {
        revenueMode = mode
        isCalculated = false
    }

    func onUniformRevenueChange(_ text: String) {
        uniformRevenueText = text
        uniformRevenue = Formatting.parseMoney(text)
        isCalculated = false
    }

    func onVariableRevenueChange(year: Int, text: String) {
        let value = Formatting.parseMoney(text)
        if year >= 0 && year < variableRevenues.count {
            variableRevenues[year] = value
        }
        isCalculated = false
    }

    func onYearsCountChange(_ years: Int) {
        let valid = min(max(years, 1), 30)
        yearsCount = valid
        if valid > variableRevenues.count {
            variableRevenues += Array(repeating: 0.0, count: valid - variableRevenues.count)
        } else {
            variableRevenues = Array(variableRevenues.prefix(valid))
        }
        isCalculated = false
    }

    func onDiscountRateChange(_ text: String) {
        discountRateText = text
        if let value = Double(text.replacingOccurrences(of: ",", with: ".")) {
            discountRate = value / 100.0
        }
        isCalculated = false
    }

    func onTarifGcalChange(_ text: String) {
        tarifGcalText = text
        let value = Double(text.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        tarifGcal = value
        if value > 0 && annualHeatGcal > 0 {
            uniformRevenue = value * annualHeatGcal
            uniformRevenueText = Formatting.formatNumber(uniformRevenue, decimals: 0)
        }
        isCalculated = false
    }

    private func recalculateOPEX() {
        guard let model = selectedModel else { return }

        annualGas = EconomicsCalculationEngine.calcAnnualGas(
            maxGas: model.maxGas,
            loadPercent: loadPercent,
            dailyHours: dailyHours,
            workDays: workDays,
            boilerCount: boilerCount
        )

        annualOPEX = EconomicsCalculationEngine.calcOPEX(
            maxGas: model.maxGas,
            loadPercent: loadPercent,
            dailyHours: dailyHours,
            workDays: workDays,
            gasPrice: gasPrice,
            maintenanceCost: maintenanceCost,
            boilerCount: boilerCount,
            efficiency: model.efficiency
        )

        annualHeatGcal = EconomicsCalculationEngine.calcAnnualHeatGcal(
            annualGas: annualGas,
            efficiency: model.efficiency
        )

        if tarifGcal > 0 && annualHeatGcal > 0 {
            uniformRevenue = tarifGcal * annualHeatGcal
            uniformRevenueText = Formatting.formatNumber(uniformRevenue, decimals: 0)
        }
    }

    private func calculateCapex(model: EconBoilerModel, count: Int, useEconomizer: Bool) -> Double {
        let boilerCost = Double(model.price) * Double(count)
        let econCost = (useEconomizer && model.economizerPrice != nil) ? Double(model.economizerPrice!) * Double(count) : 0.0
        return boilerCost + econCost
    }

    func calculate() {
        guard let model = selectedModel else { return }

        recalculateOPEX()

        let revenues = (revenueMode == "uniform")
            ? Array(repeating: uniformRevenue, count: yearsCount)
            : Array(variableRevenues.prefix(yearsCount))

        let cap = calculateCapex(model: model, count: boilerCount, useEconomizer: useEconomizer)
        capex = cap

        paybackResult = EconomicsCalculationEngine.calcPayback(
            capex: cap,
            revenues: revenues,
            opex: annualOPEX,
            discountRate: discountRate
        )

        isCalculated = true
    }
}
