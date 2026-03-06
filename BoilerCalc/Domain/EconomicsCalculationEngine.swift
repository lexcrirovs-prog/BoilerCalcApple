import Foundation

struct EconomicsCalculationEngine {

    /// Calculate annual OPEX (operating expenses).
    static func calcOPEX(
        maxGas: Double,
        loadPercent: Double,
        dailyHours: Double,
        workDays: Int,
        gasPrice: Double,
        maintenanceCost: Double,
        boilerCount: Int = 1,
        efficiency: Double = 0.92
    ) -> Double {
        let annualGas = maxGas * loadPercent * dailyHours * Double(workDays) * Double(boilerCount)
        let fuelCost = annualGas * gasPrice
        return fuelCost + maintenanceCost
    }

    /// Calculate annual gas consumption.
    static func calcAnnualGas(
        maxGas: Double,
        loadPercent: Double,
        dailyHours: Double,
        workDays: Int,
        boilerCount: Int = 1
    ) -> Double {
        return maxGas * loadPercent * dailyHours * Double(workDays) * Double(boilerCount)
    }

    /// Calculate annual heat output in Gcal.
    /// Uses natural gas calorific value 8484 kcal/m³ and boiler efficiency.
    static func calcAnnualHeatGcal(annualGas: Double, efficiency: Double) -> Double {
        return annualGas * efficiency * 8484.0 / 1_000_000.0
    }

    /// Calculate PP (simple payback) and DPBP (discounted payback).
    static func calcPayback(
        capex: Double,
        revenues: [Double],
        opex: Double,
        discountRate: Double
    ) -> PaybackResult {
        var table: [EconomicsResult] = []
        var cumCF = -capex
        var cumPV = -capex
        var pp: Double = -1.0
        var dpbp: Double = -1.0

        for i in revenues.indices {
            let year = i + 1
            let revenue = revenues[i]
            let cf = revenue - opex
            let prevCumCF = cumCF
            cumCF += cf

            let pv = cf / pow(1.0 + discountRate, Double(year))
            let prevCumPV = cumPV
            cumPV += pv

            table.append(EconomicsResult(
                year: year,
                revenue: revenue,
                cashFlow: cf,
                cumCashFlow: cumCF,
                presentValue: pv,
                cumPresentValue: cumPV
            ))

            // PP: fractional interpolation
            if pp < 0 && cumCF >= 0 && prevCumCF < 0 {
                pp = Double(year - 1) + (-prevCumCF) / cf
            }

            // DPBP: fractional interpolation
            if dpbp < 0 && cumPV >= 0 && prevCumPV < 0 {
                dpbp = Double(year - 1) + (-prevCumPV) / pv
            }
        }

        return PaybackResult(pp: pp, dpbp: dpbp, table: table)
    }
}
