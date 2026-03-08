import Foundation
import Combine

class ConverterViewModel: ObservableObject {
    @Published var selectedGroupIndex: Int = 0  // Default to pressure
    @Published var fromUnitIndex: Int = 0
    @Published var toUnitIndex: Int = 1
    @Published var inputText: String = "1"
    @Published var result: Double = 0.0
    @Published var resultText: String = ""

    init() {
        recalculate()
    }

    var currentGroup: UnitGroup {
        UnitDefinitions.groups[selectedGroupIndex]
    }

    func selectGroup(_ index: Int) {
        selectedGroupIndex = index
        fromUnitIndex = 0
        toUnitIndex = UnitDefinitions.groups[index].units.count > 1 ? 1 : 0
        recalculate()
    }

    func selectFromUnit(_ index: Int) {
        fromUnitIndex = index
        recalculate()
    }

    func selectToUnit(_ index: Int) {
        toUnitIndex = index
        recalculate()
    }

    func onInputChange(_ text: String) {
        inputText = text
        recalculate()
    }

    func swapUnits() {
        let tmp = fromUnitIndex
        fromUnitIndex = toUnitIndex
        toUnitIndex = tmp
        recalculate()
    }

    func applyPreset(fromName: String, toName: String) {
        let group = UnitDefinitions.groups[selectedGroupIndex]
        if let fromIdx = group.units.firstIndex(where: { $0.name == fromName }),
           let toIdx = group.units.firstIndex(where: { $0.name == toName }) {
            fromUnitIndex = fromIdx
            toUnitIndex = toIdx
            recalculate()
        }
    }

    private func recalculate() {
        let input = Double(inputText.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        result = UnitConversionEngine.convert(
            groupIndex: selectedGroupIndex,
            fromUnitIndex: fromUnitIndex,
            toUnitIndex: toUnitIndex,
            value: input
        )
        resultText = Formatting.formatTrimmed(result, decimals: 6)
    }
}
