import Foundation

struct BoilerCatalogue {
    static let steamBoilers: [BoilerModel] = [
        BoilerModel(id: "s500", name: "Premium S - 500", minSteam: 250, maxSteam: 500, gas8484: 39),
        BoilerModel(id: "s1000", name: "Premium S - 1000", minSteam: 500, maxSteam: 1000, gas8484: 78),
        BoilerModel(id: "s1500", name: "Premium S - 1500", minSteam: 750, maxSteam: 1500, gas8484: 116),
        BoilerModel(id: "s2000", name: "Premium S - 2000", minSteam: 1000, maxSteam: 2000, gas8484: 155),
        BoilerModel(id: "s2500", name: "Premium S - 2500", minSteam: 1250, maxSteam: 2500, gas8484: 193),
        BoilerModel(id: "s3000", name: "Premium S - 3000", minSteam: 1500, maxSteam: 3000, gas8484: 233),
        BoilerModel(id: "s3500", name: "Premium S - 3500", minSteam: 1750, maxSteam: 3500, gas8484: 270),
        BoilerModel(id: "s4000", name: "Premium S - 4000", minSteam: 2000, maxSteam: 4000, gas8484: 308),
        BoilerModel(id: "s5000", name: "Premium S - 5000", minSteam: 2500, maxSteam: 5000, gas8484: 384),
        BoilerModel(id: "s15000", name: "Premium S - 15000 (до 15т)", minSteam: 0, maxSteam: 15000, gas8484: 1152)
    ]

    static let waterBoilers: [WaterBoilerModel] = [
        WaterBoilerModel(series: "Premium C", power: 250, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 500, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 750, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 1000, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 1250, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 1500, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 1750, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 2000, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 2500, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 3000, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 3500, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 4000, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 5000, isPremiumE: false),
        WaterBoilerModel(series: "Premium C", power: 6000, isPremiumE: false),
        WaterBoilerModel(series: "Premium E", power: 7000, isPremiumE: true),
        WaterBoilerModel(series: "Premium E", power: 8000, isPremiumE: true),
        WaterBoilerModel(series: "Premium E", power: 9000, isPremiumE: true),
        WaterBoilerModel(series: "Premium E", power: 10000, isPremiumE: true)
    ]
}
