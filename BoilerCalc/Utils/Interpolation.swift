import Foundation

struct Interpolation {
    static func lerp(x: Double, x0: Double, y0: Double, x1: Double, y1: Double) -> Double {
        if x1 == x0 { return y0 }
        return y0 + (x - x0) * (y1 - y0) / (x1 - x0)
    }

    static func interpolateFromTable<T>(
        _ table: [T],
        keySelector: (T) -> Double,
        valueSelector: (T) -> Double,
        targetKey: Double
    ) -> Double {
        if table.isEmpty { return 0.0 }
        let firstKey = keySelector(table.first!)
        let lastKey = keySelector(table.last!)
        if targetKey <= firstKey { return valueSelector(table.first!) }
        if targetKey >= lastKey { return valueSelector(table.last!) }

        for i in 0..<(table.count - 1) {
            let k0 = keySelector(table[i])
            let k1 = keySelector(table[i + 1])
            if targetKey >= k0 && targetKey <= k1 {
                return lerp(
                    x: targetKey,
                    x0: k0, y0: valueSelector(table[i]),
                    x1: k1, y1: valueSelector(table[i + 1])
                )
            }
        }
        return valueSelector(table.last!)
    }
}
