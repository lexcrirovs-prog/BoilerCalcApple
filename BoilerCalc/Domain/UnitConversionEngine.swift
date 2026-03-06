import Foundation

struct UnitConversionEngine {

    /// Convert value between units within the same group by indices.
    static func convert(
        groupIndex: Int,
        fromUnitIndex: Int,
        toUnitIndex: Int,
        value: Double
    ) -> Double {
        let groups = UnitDefinitions.groups
        guard groupIndex >= 0 && groupIndex < groups.count else { return value }

        let group = groups[groupIndex]
        guard fromUnitIndex >= 0 && fromUnitIndex < group.units.count else { return value }
        guard toUnitIndex >= 0 && toUnitIndex < group.units.count else { return value }

        if fromUnitIndex == toUnitIndex { return value }

        let baseValue = group.units[fromUnitIndex].toBase(value)
        return group.units[toUnitIndex].fromBase(baseValue)
    }

    /// Convert by unit names within a group.
    static func convert(
        groupIndex: Int,
        fromUnitName: String,
        toUnitName: String,
        value: Double
    ) -> Double {
        let groups = UnitDefinitions.groups
        guard groupIndex >= 0 && groupIndex < groups.count else { return value }

        let group = groups[groupIndex]
        guard let fromIdx = group.units.firstIndex(where: { $0.name == fromUnitName }),
              let toIdx = group.units.firstIndex(where: { $0.name == toUnitName }) else {
            return value
        }

        return convert(groupIndex: groupIndex, fromUnitIndex: fromIdx, toUnitIndex: toIdx, value: value)
    }
}
