import Foundation

struct HeatCalculationEngine {

    /// Design indoor temperature per ГОСТ 30494-2011, °C
    private static let tVN: Double = 20.0

    /// Heat load per shower unit, kW (СП 30.13330)
    private static let qDush: Double = 8.0

    /// Heat load per sink, kW (СП 30.13330)
    private static let qUmyv: Double = 1.2

    /// Heating load formula Д.1 (СП 50.13330.2024)
    /// Q_от = q₀ × V × (T_VN − t_нр) / 1000 [kW]
    static func calcHeatingLoad(q0: Double, volume: Double, tDesign: Double) -> Double {
        return q0 * volume * (tVN - tDesign) / 1000.0
    }

    /// DHW (domestic hot water) load calculation (СП 30.13330)
    /// Q_гвс = n_д × 8 + n_у × 1.2 [kW]
    static func calcDHWLoad(showers: Int, sinks: Int) -> Double {
        return Double(showers) * qDush + Double(sinks) * qUmyv
    }

    /// Annual heating energy formula Б.12 (СП 50.13330.2024)
    /// Q_год = Q_от × 24 × z_от × (T_VN − t_от) / ((T_VN − t_нр) × 1000) [MWh/year]
    static func calcAnnualHeat(qHeating: Double, heatingDays: Int, tHeating: Double, tDesign: Double) -> Double {
        let denominator = tVN - tDesign
        if denominator == 0.0 { return 0.0 }
        return qHeating * 24.0 * Double(heatingDays) * (tVN - tHeating) / (denominator * 1000.0)
    }

    /// Heating degree-days ГСОП (formula 5.2 СП 50.13330.2024)
    /// ГСОП = (T_VN − t_от) × z_от [°C·day]
    static func calcGSOP(tHeating: Double, heatingDays: Int) -> Double {
        return (tVN - tHeating) * Double(heatingDays)
    }

    /// T_VN constant for external access
    static func getDesignIndoorTemp() -> Double { tVN }
}
