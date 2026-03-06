import Foundation
import Combine

class HeatCalcViewModel: ObservableObject {
    // City
    @Published var cityQuery: String = ""
    @Published var selectedCity: CityClimate?
    @Published var filteredCities: [CityClimate] = []
    @Published var isCityDropdownExpanded: Bool = false

    // Buildings
    @Published var buildings: [Building] = [Building(id: 1)]

    // DHW
    @Published var showers: Int = 0
    @Published var sinks: Int = 0

    // Results
    @Published var qHeating: Double = 0.0
    @Published var qDHW: Double = 0.0
    @Published var qTotal: Double = 0.0
    @Published var annualHeat: Double = 0.0
    @Published var gsop: Double = 0.0
    @Published var selectedBoilers: [SelectedWaterBoiler] = []
    @Published var isCalculated: Bool = false
    @Published var heatingDays: Int = 0

    private let allCities = ClimateDatabase.cities

    func onCityQueryChange(_ text: String) {
        cityQuery = text
        selectedCity = nil
        isCalculated = false

        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            filteredCities = allCities
        } else {
            filteredCities = allCities.filter { CyrillicNormalization.matches(query: text, target: $0.name) }
        }
        isCityDropdownExpanded = !filteredCities.isEmpty
    }

    func selectCity(_ city: CityClimate) {
        selectedCity = city
        cityQuery = city.name
        isCityDropdownExpanded = false
        heatingDays = city.heatingDays
        isCalculated = false
    }

    func dismissCityDropdown() {
        isCityDropdownExpanded = false
    }

    func addBuilding() {
        let nextId = (buildings.map { $0.id }.max() ?? 0) + 1
        buildings.append(Building(id: nextId))
        isCalculated = false
    }

    func removeBuilding(id: Int) {
        if buildings.count <= 1 { return }
        buildings.removeAll { $0.id == id }
        for i in buildings.indices {
            buildings[i].id = i + 1
        }
        isCalculated = false
    }

    func updateBuilding(id: Int, building: Building) {
        if let idx = buildings.firstIndex(where: { $0.id == id }) {
            buildings[idx] = building
            isCalculated = false
        }
    }

    func calculate() {
        guard let city = selectedCity else { return }

        var totalHeatingLoad = 0.0
        for building in buildings {
            let volume = building.useManualVolume ? building.volume : building.width * building.length * building.height
            if volume > 0 {
                totalHeatingLoad += HeatCalculationEngine.calcHeatingLoad(
                    q0: building.q0,
                    volume: volume,
                    tDesign: city.tDesign
                )
            }
        }

        let dhw = HeatCalculationEngine.calcDHWLoad(showers: showers, sinks: sinks)
        let total = totalHeatingLoad + dhw

        let annual = HeatCalculationEngine.calcAnnualHeat(
            qHeating: totalHeatingLoad,
            heatingDays: city.heatingDays,
            tHeating: city.tHeating,
            tDesign: city.tDesign
        )

        let gsopVal = HeatCalculationEngine.calcGSOP(
            tHeating: city.tHeating,
            heatingDays: city.heatingDays
        )

        let boilers = BoilerSelectionEngine.selectWaterBoilers(powerKW: total)

        qHeating = totalHeatingLoad
        qDHW = dhw
        qTotal = total
        annualHeat = annual
        gsop = gsopVal
        selectedBoilers = boilers
        isCalculated = true
    }
}
