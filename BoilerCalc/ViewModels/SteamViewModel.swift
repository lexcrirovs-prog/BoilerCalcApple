import Foundation
import Combine

class SteamViewModel: ObservableObject {
    // Inputs
    @Published var pressureBar: Double = 8.0
    @Published var pressureText: String = "8"
    @Published var temperatureC: Double = 175.4
    @Published var temperatureText: String = "175,4"
    @Published var steamCapacityKgH: Double = 2000.0
    @Published var steamCapacityText: String = "2000"
    @Published var calorificKcal: Double = 8484.0
    @Published var calorificText: String = "8484"
    @Published var efficiencyPercent: Double = 92.0
    @Published var efficiencyText: String = "92"

    // Results
    @Published var steamProps: SteamProperties?
    @Published var powerMW: Double = 0.0
    @Published var gasConsumption: Double = 0.0
    @Published var selectedBoilers: [SelectedSteamBoiler] = []

    // Unit display modes
    @Published var pressureUnit: String = "бар"     // бар | МПа | кгс/см²
    @Published var tempUnit: String = "\u{00B0}C"   // °C | °F
    @Published var capacityUnit: String = "кг/ч"    // кг/ч | т/ч
    @Published var powerUnit: String = "МВт"        // МВт | Гкал/ч | кВт

    private var isUpdatingFromTemp = false

    init() {
        calculate()
    }

    // MARK: - Pressure change
    func onPressureChange(_ text: String) {
        if isUpdatingFromTemp { return }
        pressureText = text
        let parsed = Double(text.replacingOccurrences(of: ",", with: "."))
        let bar = min(max(parsed ?? pressureBar, 0.0), 16.0)
        pressureBar = bar

        let props = SteamCalculationEngine.getSteamProperties(pressureGauge: bar)
        temperatureC = props.temperature
        temperatureText = Formatting.formatTrimmed(props.temperature, decimals: 1)
        calculate()
    }

    // MARK: - Temperature change
    func onTemperatureChange(_ text: String) {
        temperatureText = text
        let parsed = Double(text.replacingOccurrences(of: ",", with: "."))
        let temp = min(max(parsed ?? temperatureC, 99.0), 204.3)
        temperatureC = temp

        isUpdatingFromTemp = true
        let bar = SteamCalculationEngine.getPressureFromTemp(tempC: temp)
        pressureBar = bar
        pressureText = Formatting.formatTrimmed(bar, decimals: 2)
        isUpdatingFromTemp = false
        calculate()
    }

    func onPressureSliderChange(_ value: Double) {
        pressureBar = value
        pressureText = Formatting.formatTrimmed(value, decimals: 2)
        let props = SteamCalculationEngine.getSteamProperties(pressureGauge: value)
        temperatureC = props.temperature
        temperatureText = Formatting.formatTrimmed(props.temperature, decimals: 1)
        calculate()
    }

    func onTemperatureSliderChange(_ value: Double) {
        temperatureC = value
        temperatureText = Formatting.formatTrimmed(value, decimals: 1)
        let bar = SteamCalculationEngine.getPressureFromTemp(tempC: value)
        pressureBar = bar
        pressureText = Formatting.formatTrimmed(bar, decimals: 2)
        calculate()
    }

    func onSteamCapacityChange(_ text: String) {
        steamCapacityText = text
        let parsed = Double(text.replacingOccurrences(of: ",", with: "."))
        steamCapacityKgH = min(max(parsed ?? steamCapacityKgH, 0.0), 15000.0)
        calculate()
    }

    func onSteamCapacitySliderChange(_ value: Double) {
        steamCapacityKgH = value
        steamCapacityText = Formatting.formatNumber(value, decimals: 0)
        calculate()
    }

    func onCalorificChange(_ text: String) {
        calorificText = text
        calorificKcal = Double(text.replacingOccurrences(of: ",", with: ".")) ?? calorificKcal
        calculate()
    }

    func onEfficiencyChange(_ text: String) {
        efficiencyText = text
        let parsed = Double(text.replacingOccurrences(of: ",", with: "."))
        efficiencyPercent = min(max(parsed ?? efficiencyPercent, 50.0), 100.0)
        calculate()
    }

    // MARK: - Unit toggles
    func togglePressureUnit() {
        switch pressureUnit {
        case "бар": pressureUnit = "МПа"
        case "МПа": pressureUnit = "кгс/см\u{00B2}"
        default: pressureUnit = "бар"
        }
    }

    func toggleTempUnit() {
        tempUnit = (tempUnit == "\u{00B0}C") ? "\u{00B0}F" : "\u{00B0}C"
    }

    func toggleCapacityUnit() {
        capacityUnit = (capacityUnit == "кг/ч") ? "т/ч" : "кг/ч"
    }

    func togglePowerUnit() {
        switch powerUnit {
        case "МВт": powerUnit = "Гкал/ч"
        case "Гкал/ч": powerUnit = "кВт"
        default: powerUnit = "МВт"
        }
    }

    // MARK: - Display converters
    func displayPressure() -> String {
        switch pressureUnit {
        case "МПа": return Formatting.formatTrimmed(pressureBar * 0.1, decimals: 4)
        case "кгс/см\u{00B2}": return Formatting.formatTrimmed(pressureBar * 1.01972, decimals: 3)
        default: return Formatting.formatTrimmed(pressureBar, decimals: 2)
        }
    }

    func displayTemperature() -> String {
        if tempUnit == "\u{00B0}F" {
            return Formatting.formatTrimmed(temperatureC * 9.0 / 5.0 + 32.0, decimals: 1)
        }
        return Formatting.formatTrimmed(temperatureC, decimals: 1)
    }

    func displayCapacity() -> String {
        if capacityUnit == "т/ч" {
            return Formatting.formatTrimmed(steamCapacityKgH / 1000.0, decimals: 3)
        }
        return Formatting.formatNumber(steamCapacityKgH, decimals: 0)
    }

    func displayPower() -> String {
        switch powerUnit {
        case "Гкал/ч": return Formatting.formatTrimmed(powerMW * 1.163, decimals: 4)
        case "кВт": return Formatting.formatTrimmed(powerMW * 1000.0, decimals: 1)
        default: return Formatting.formatTrimmed(powerMW, decimals: 4)
        }
    }

    // MARK: - Calculation
    private func calculate() {
        let props = SteamCalculationEngine.getSteamProperties(pressureGauge: pressureBar)
        steamProps = props

        gasConsumption = SteamCalculationEngine.calcGasConsumption(
            steamKgH: steamCapacityKgH,
            hDoublePrime: props.hDoublePrime,
            calorificKcal: calorificKcal,
            efficiency: efficiencyPercent / 100.0
        )

        powerMW = SteamCalculationEngine.calcPowerMW(
            steamKgH: steamCapacityKgH,
            latentHeat: props.latentHeat
        )

        selectedBoilers = BoilerSelectionEngine.selectSteamBoilers(requiredKgH: steamCapacityKgH)
    }
}
