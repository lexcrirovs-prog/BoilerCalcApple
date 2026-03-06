import Foundation

struct SteamProperties {
    let temperature: Double
    let hPrime: Double
    let hDoublePrime: Double
    let latentHeat: Double
    let specificVolume: Double
}

struct SteamCalculationEngine {

    private static let table = SteamTable.entries

    /// Feedwater enthalpy at ~60°C (kJ/kg)
    private static let hFeedwater: Double = 251.0

    /// Calorific value conversion: kcal → kJ
    private static let kcalToKJ: Double = 4.1868

    /// Get steam properties by gauge pressure (0..16 bar).
    /// Uses linear interpolation on IAPWS-IF97 table.
    static func getSteamProperties(pressureGauge: Double) -> SteamProperties {
        let p = min(max(pressureGauge, 0.0), 16.0)
        let t = Interpolation.interpolateFromTable(table, keySelector: { $0.pressureGauge }, valueSelector: { $0.temperature }, targetKey: p)
        let hP = Interpolation.interpolateFromTable(table, keySelector: { $0.pressureGauge }, valueSelector: { $0.hPrime }, targetKey: p)
        let hPP = Interpolation.interpolateFromTable(table, keySelector: { $0.pressureGauge }, valueSelector: { $0.hDoublePrime }, targetKey: p)
        let v = Interpolation.interpolateFromTable(table, keySelector: { $0.pressureGauge }, valueSelector: { $0.specificVolume }, targetKey: p)
        return SteamProperties(
            temperature: t,
            hPrime: hP,
            hDoublePrime: hPP,
            latentHeat: hPP - hP,
            specificVolume: v
        )
    }

    /// Reverse lookup: temperature → gauge pressure.
    static func getPressureFromTemp(tempC: Double) -> Double {
        let t = min(max(tempC, table.first!.temperature), table.last!.temperature)
        return Interpolation.interpolateFromTable(table, keySelector: { $0.temperature }, valueSelector: { $0.pressureGauge }, targetKey: t)
    }

    /// Gas consumption calculation.
    /// - Parameters:
    ///   - steamKgH: Steam flow rate, kg/h
    ///   - hDoublePrime: Enthalpy of steam, kJ/kg
    ///   - calorificKcal: Fuel calorific value, kcal/m³ (default 8484)
    ///   - efficiency: Boiler efficiency (default 0.92)
    /// - Returns: Gas consumption, m³/h
    static func calcGasConsumption(
        steamKgH: Double,
        hDoublePrime: Double,
        calorificKcal: Double = 8484.0,
        efficiency: Double = 0.92
    ) -> Double {
        let qNeeded = steamKgH * (hDoublePrime - hFeedwater)
        let qFuel = calorificKcal * kcalToKJ
        return (qFuel * efficiency > 0) ? qNeeded / (qFuel * efficiency) : 0.0
    }

    /// Calculate thermal power from steam flow.
    /// Q = D * r / 3_600_000 (MW)
    static func calcPowerMW(steamKgH: Double, latentHeat: Double) -> Double {
        return steamKgH * latentHeat / 3_600_000.0
    }
}
