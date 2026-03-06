import Foundation

struct EconBoilerDatabase {
    static let steam: [EconBoilerModel] = [
        EconBoilerModel(id: "s500", name: "Premium S - 500", maxGas: 39.0, price: 1864570, efficiency: 0.92),
        EconBoilerModel(id: "s1000", name: "Premium S - 1000", maxGas: 78.0, price: 2833410, efficiency: 0.92),
        EconBoilerModel(id: "s1500", name: "Premium S - 1500", maxGas: 116.0, price: 3100600, efficiency: 0.92, economizerPrice: 1000000),
        EconBoilerModel(id: "s2000", name: "Premium S - 2000", maxGas: 155.0, price: 3455323, efficiency: 0.92, economizerPrice: 1245000),
        EconBoilerModel(id: "s2500", name: "Premium S - 2500", maxGas: 193.0, price: 3629127, efficiency: 0.92, economizerPrice: 1450000),
        EconBoilerModel(id: "s3000", name: "Premium S - 3000", maxGas: 247.0, price: 4217792, efficiency: 0.92, economizerPrice: 1600000),
        EconBoilerModel(id: "s3500", name: "Premium S - 3500", maxGas: 270.0, price: 5079409, efficiency: 0.92, economizerPrice: 1800000),
        EconBoilerModel(id: "s4000", name: "Premium S - 4000", maxGas: 308.0, price: 5760302, efficiency: 0.92, economizerPrice: 1951000),
        EconBoilerModel(id: "s5000", name: "Premium S - 5000", maxGas: 384.0, price: 6739180, efficiency: 0.92, economizerPrice: 2250000)
    ]

    static let water: [EconBoilerModel] = [
        EconBoilerModel(id: "c250", name: "Premium C - 250", maxGas: 28.8, price: 550000, efficiency: 0.92),
        EconBoilerModel(id: "c500", name: "Premium C - 500", maxGas: 54.6, price: 700000, efficiency: 0.92),
        EconBoilerModel(id: "c1000", name: "Premium C - 1000", maxGas: 110.2, price: 1250000, efficiency: 0.92),
        EconBoilerModel(id: "c1500", name: "Premium C - 1500", maxGas: 165.2, price: 1650000, efficiency: 0.92),
        EconBoilerModel(id: "c2000", name: "Premium C - 2000", maxGas: 217.5, price: 2300000, efficiency: 0.92),
        EconBoilerModel(id: "c2500", name: "Premium C - 2500", maxGas: 271.0, price: 2500000, efficiency: 0.92),
        EconBoilerModel(id: "c3000", name: "Premium C - 3000", maxGas: 326.6, price: 2950000, efficiency: 0.92),
        EconBoilerModel(id: "c4000", name: "Premium C - 4000", maxGas: 426.7, price: 3925000, efficiency: 0.92)
    ]

    static let waterE: [EconBoilerModel] = [
        EconBoilerModel(id: "e1000", name: "Premium E - 1000", maxGas: 109.0, price: 1600000, efficiency: 0.93),
        EconBoilerModel(id: "e2000", name: "Premium E - 2000", maxGas: 218.0, price: 3000000, efficiency: 0.93),
        EconBoilerModel(id: "e2500", name: "Premium E - 2500", maxGas: 273.0, price: 3780000, efficiency: 0.93),
        EconBoilerModel(id: "e3000", name: "Premium E - 3000", maxGas: 327.0, price: 4200000, efficiency: 0.93),
        EconBoilerModel(id: "e3500", name: "Premium E - 3500", maxGas: 382.0, price: 5200000, efficiency: 0.93),
        EconBoilerModel(id: "e4000", name: "Premium E - 4000", maxGas: 436.0, price: 5400000, efficiency: 0.93),
        EconBoilerModel(id: "e5000", name: "Premium E - 5000", maxGas: 545.0, price: 5950000, efficiency: 0.93),
        EconBoilerModel(id: "e6000", name: "Premium E - 6000", maxGas: 655.0, price: 6850000, efficiency: 0.93),
        EconBoilerModel(id: "e7000", name: "Premium E - 7000", maxGas: 764.0, price: 8375000, efficiency: 0.93),
        EconBoilerModel(id: "e8000", name: "Premium E - 8000", maxGas: 873.0, price: 9800000, efficiency: 0.93),
        EconBoilerModel(id: "e10000", name: "Premium E - 10000", maxGas: 1091.0, price: 12000000, efficiency: 0.93),
        EconBoilerModel(id: "e12000", name: "Premium E - 12000", maxGas: 1309.0, price: 14500000, efficiency: 0.93)
    ]

    static var all: [EconBoilerModel] { steam + water + waterE }
}
