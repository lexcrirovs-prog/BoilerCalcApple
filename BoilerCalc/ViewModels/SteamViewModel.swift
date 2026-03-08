import Foundation
import SwiftUI
import Combine

class SteamViewModel: ObservableObject {
    // Inputs (base units)
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

    // MARK: - Conversion helpers

    private func barToDisplay(_ bar: Double, _ unit: String) -> Double {
        switch unit {
        case "МПа": return bar * 0.1
        case "кгс/см\u{00B2}": return bar * 1.01972
        default: return bar
        }
    }

    private func displayToBar(_ value: Double, _ unit: String) -> Double {
        switch unit {
        case "МПа": return value * 10.0
        case "кгс/см\u{00B2}": return value / 1.01972
        default: return value
        }
    }

    private func pressureDecimals(_ unit: String) -> Int {
        switch unit {
        case "МПа": return 4
        case "кгс/см\u{00B2}": return 3
        default: return 2
        }
    }

    private func celsiusToDisplay(_ c: Double, _ unit: String) -> Double {
        if unit == "\u{00B0}F" { return c * 9.0 / 5.0 + 32.0 }
        return c
    }

    private func displayToCelsius(_ value: Double, _ unit: String) -> Double {
        if unit == "\u{00B0}F" { return (value - 32.0) * 5.0 / 9.0 }
        return value
    }

    private func kghToDisplay(_ kgh: Double, _ unit: String) -> Double {
        if unit == "т/ч" { return kgh / 1000.0 }
        return kgh
    }

    private func displayToKgh(_ value: Double, _ unit: String) -> Double {
        if unit == "т/ч" { return value * 1000.0 }
        return value
    }

    private func capacityDecimals(_ unit: String) -> Int {
        if unit == "т/ч" { return 3 }
        return 0
    }

    private func formatDisplay(_ value: Double, _ decimals: Int) -> String {
        if decimals > 0 {
            return Formatting.formatTrimmed(value, decimals: decimals)
        }
        return Formatting.formatNumber(value, decimals: 0)
    }

    // MARK: - Slider bindings & ranges

    var pressureSliderBinding: Binding<Double> {
        Binding(
            get: { self.barToDisplay(self.pressureBar, self.pressureUnit) },
            set: { self.onPressureSliderChange($0) }
        )
    }

    var pressureSliderRange: ClosedRange<Double> {
        switch pressureUnit {
        case "МПа": return 0...1.6
        case "кгс/см\u{00B2}": return 0...16.316
        default: return 0...16
        }
    }

    var temperatureSliderBinding: Binding<Double> {
        Binding(
            get: { self.celsiusToDisplay(self.temperatureC, self.tempUnit) },
            set: { self.onTemperatureSliderChange($0) }
        )
    }

    var temperatureSliderRange: ClosedRange<Double> {
        if tempUnit == "\u{00B0}F" { return 210.2...399.74 }
        return 99...204.3
    }

    var capacitySliderBinding: Binding<Double> {
        Binding(
            get: { self.kghToDisplay(self.steamCapacityKgH, self.capacityUnit) },
            set: { self.onSteamCapacitySliderChange($0) }
        )
    }

    var capacitySliderRange: ClosedRange<Double> {
        if capacityUnit == "т/ч" { return 0...15 }
        return 0...15000
    }

    // MARK: - Pressure change

    func onPressureChange(_ text: String) {
        if isUpdatingFromTemp { return }
        pressureText = text
        let parsed = Double(text.replacingOccurrences(of: ",", with: "."))
        let bar: Double
        if let p = parsed {
            bar = min(max(displayToBar(p, pressureUnit), 0.0), 16.0)
        } else {
            bar = pressureBar
        }
        pressureBar = bar

        let props = SteamCalculationEngine.getSteamProperties(pressureGauge: bar)
        temperatureC = props.temperature
        temperatureText = formatDisplay(celsiusToDisplay(props.temperature, tempUnit), 1)
        calculate()
    }

    // MARK: - Temperature change

    func onTemperatureChange(_ text: String) {
        temperatureText = text
        let parsed = Double(text.replacingOccurrences(of: ",", with: "."))
        let temp: Double
        if let p = parsed {
            temp = min(max(displayToCelsius(p, tempUnit), 99.0), 204.3)
        } else {
            temp = temperatureC
        }
        temperatureC = temp

        isUpdatingFromTemp = true
        let bar = SteamCalculationEngine.getPressureFromTemp(tempC: temp)
        pressureBar = bar
        pressureText = formatDisplay(barToDisplay(bar, pressureUnit), pressureDecimals(pressureUnit))
        isUpdatingFromTemp = false
        calculate()
    }

    func onPressureSliderChange(_ value: Double) {
        let bar = displayToBar(value, pressureUnit)
        pressureBar = bar
        pressureText = formatDisplay(value, pressureDecimals(pressureUnit))
        let props = SteamCalculationEngine.getSteamProperties(pressureGauge: bar)
        temperatureC = props.temperature
        temperatureText = formatDisplay(celsiusToDisplay(props.temperature, tempUnit), 1)
        calculate()
    }

    func onTemperatureSliderChange(_ value: Double) {
        let temp = displayToCelsius(value, tempUnit)
        temperatureC = temp
        temperatureText = formatDisplay(value, 1)
        let bar = SteamCalculationEngine.getPressureFromTemp(tempC: temp)
        pressureBar = bar
        pressureText = formatDisplay(barToDisplay(bar, pressureUnit), pressureDecimals(pressureUnit))
        calculate()
    }

    func onSteamCapacityChange(_ text: String) {
        steamCapacityText = text
        let parsed = Double(text.replacingOccurrences(of: ",", with: "."))
        if let p = parsed {
            steamCapacityKgH = min(max(displayToKgh(p, capacityUnit), 0.0), 15000.0)
        }
        calculate()
    }

    func onSteamCapacitySliderChange(_ value: Double) {
        let kgH = displayToKgh(value, capacityUnit)
        steamCapacityKgH = kgH
        steamCapacityText = formatDisplay(value, capacityDecimals(capacityUnit))
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
        let next: String
        switch pressureUnit {
        case "бар": next = "МПа"
        case "МПа": next = "кгс/см\u{00B2}"
        default: next = "бар"
        }
        pressureUnit = next
        pressureText = formatDisplay(barToDisplay(pressureBar, next), pressureDecimals(next))
    }

    func toggleTempUnit() {
        let next = (tempUnit == "\u{00B0}C") ? "\u{00B0}F" : "\u{00B0}C"
        tempUnit = next
        temperatureText = formatDisplay(celsiusToDisplay(temperatureC, next), 1)
    }

    func toggleCapacityUnit() {
        let next = (capacityUnit == "кг/ч") ? "т/ч" : "кг/ч"
        capacityUnit = next
        steamCapacityText = formatDisplay(kghToDisplay(steamCapacityKgH, next), capacityDecimals(next))
    }

    func togglePowerUnit() {
        switch powerUnit {
        case "МВт": powerUnit = "Гкал/ч"
        case "Гкал/ч": powerUnit = "кВт"
        default: powerUnit = "МВт"
        }
    }

    // MARK: - Display converters (for results section)

    func displayPressure() -> String {
        return formatDisplay(barToDisplay(pressureBar, pressureUnit), pressureDecimals(pressureUnit))
    }

    func displayTemperature() -> String {
        return formatDisplay(celsiusToDisplay(temperatureC, tempUnit), 1)
    }

    func displayCapacity() -> String {
        return formatDisplay(kghToDisplay(steamCapacityKgH, capacityUnit), capacityDecimals(capacityUnit))
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
