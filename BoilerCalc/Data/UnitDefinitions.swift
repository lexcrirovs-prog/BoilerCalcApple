import Foundation

struct UnitDefinitions {
    static let groups: [UnitGroup] = [
        // 0: Давление (base: бар)
        UnitGroup(name: "Давление", units: [
            UnitDef(name: "бар", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "кгс/см\u{00B2}", toBase: { $0 / 1.01972 }, fromBase: { $0 * 1.01972 })
        ]),
        // 1: Температура (base: °C)
        UnitGroup(name: "Температура", units: [
            UnitDef(name: "\u{00B0}C", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "K", toBase: { $0 - 273.15 }, fromBase: { $0 + 273.15 }),
            UnitDef(name: "\u{00B0}F", toBase: { ($0 - 32.0) * 5.0 / 9.0 }, fromBase: { $0 * 9.0 / 5.0 + 32.0 })
        ]),
        // 2: Паропроизводительность (base: кг/ч)
        UnitGroup(name: "Паропроизводительность", units: [
            UnitDef(name: "кг/ч", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "т/ч", toBase: { $0 * 1000.0 }, fromBase: { $0 / 1000.0 }),
            UnitDef(name: "кг/с", toBase: { $0 * 3600.0 }, fromBase: { $0 / 3600.0 })
        ]),
        // 3: Давление расш. (base: Па)
        UnitGroup(name: "Давление расш.", units: [
            UnitDef(name: "Па", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "кПа", toBase: { $0 * 1000.0 }, fromBase: { $0 / 1000.0 }),
            UnitDef(name: "МПа", toBase: { $0 * 1_000_000.0 }, fromBase: { $0 / 1_000_000.0 }),
            UnitDef(name: "бар", toBase: { $0 * 100_000.0 }, fromBase: { $0 / 100_000.0 }),
            UnitDef(name: "мбар", toBase: { $0 * 100.0 }, fromBase: { $0 / 100.0 }),
            UnitDef(name: "кгс/см\u{00B2}", toBase: { $0 * 98066.5 }, fromBase: { $0 / 98066.5 }),
            UnitDef(name: "атм", toBase: { $0 * 101325.0 }, fromBase: { $0 / 101325.0 }),
            UnitDef(name: "мм рт.ст.", toBase: { $0 * 133.322 }, fromBase: { $0 / 133.322 }),
            UnitDef(name: "мм вод.ст.", toBase: { $0 * 9.80665 }, fromBase: { $0 / 9.80665 }),
            UnitDef(name: "psi", toBase: { $0 * 6894.76 }, fromBase: { $0 / 6894.76 })
        ]),
        // 4: Тепловая мощность (base: Вт)
        UnitGroup(name: "Тепловая мощность", units: [
            UnitDef(name: "Вт", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "кВт", toBase: { $0 * 1000.0 }, fromBase: { $0 / 1000.0 }),
            UnitDef(name: "МВт", toBase: { $0 * 1_000_000.0 }, fromBase: { $0 / 1_000_000.0 }),
            UnitDef(name: "Гкал/ч", toBase: { $0 * 1_163_000.0 }, fromBase: { $0 / 1_163_000.0 }),
            UnitDef(name: "ккал/ч", toBase: { $0 * 1.163 }, fromBase: { $0 / 1.163 }),
            UnitDef(name: "BTU/h", toBase: { $0 * 0.29307 }, fromBase: { $0 / 0.29307 })
        ]),
        // 5: Температура полн. (base: °C)
        UnitGroup(name: "Температура полн.", units: [
            UnitDef(name: "\u{00B0}C", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "K", toBase: { $0 - 273.15 }, fromBase: { $0 + 273.15 }),
            UnitDef(name: "\u{00B0}F", toBase: { ($0 - 32.0) * 5.0 / 9.0 }, fromBase: { $0 * 9.0 / 5.0 + 32.0 })
        ]),
        // 6: Расход пара (base: кг/ч)
        UnitGroup(name: "Расход пара", units: [
            UnitDef(name: "кг/ч", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "т/ч", toBase: { $0 * 1000.0 }, fromBase: { $0 / 1000.0 }),
            UnitDef(name: "кг/с", toBase: { $0 * 3600.0 }, fromBase: { $0 / 3600.0 }),
            UnitDef(name: "т/сут", toBase: { $0 * 1000.0 / 24.0 }, fromBase: { $0 / 1000.0 * 24.0 }),
            UnitDef(name: "МВт", toBase: { $0 * 1800.0 }, fromBase: { $0 / 1800.0 }),
            UnitDef(name: "кВт", toBase: { $0 * 1.8 }, fromBase: { $0 / 1.8 })
        ]),
        // 7: Энтальпия (base: кДж/кг)
        UnitGroup(name: "Энтальпия", units: [
            UnitDef(name: "кДж/кг", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "ккал/кг", toBase: { $0 * 4.1868 }, fromBase: { $0 / 4.1868 }),
            UnitDef(name: "BTU/lb", toBase: { $0 * 2.326 }, fromBase: { $0 / 2.326 })
        ]),
        // 8: Удельный объём (base: м³/кг)
        UnitGroup(name: "Удельный объём", units: [
            UnitDef(name: "м\u{00B3}/кг", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "л/кг", toBase: { $0 / 1000.0 }, fromBase: { $0 * 1000.0 }),
            UnitDef(name: "ft\u{00B3}/lb", toBase: { $0 / 0.062428 }, fromBase: { $0 * 0.062428 })
        ]),
        // 9: Расход топлива (base: м³/ч)
        UnitGroup(name: "Расход топлива", units: [
            UnitDef(name: "м\u{00B3}/ч", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "нм\u{00B3}/ч", toBase: { $0 * 1.0 }, fromBase: { $0 * 1.0 }),
            UnitDef(name: "тыс.м\u{00B3}/сут", toBase: { $0 * 1000.0 / 24.0 }, fromBase: { $0 / 1000.0 * 24.0 }),
            UnitDef(name: "кг/ч", toBase: { $0 / 0.72 }, fromBase: { $0 * 0.72 })
        ]),
        // 10: Теплотворность (base: МДж/м³)
        UnitGroup(name: "Теплотворность", units: [
            UnitDef(name: "МДж/м\u{00B3}", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "ккал/м\u{00B3}", toBase: { $0 / 238.846 }, fromBase: { $0 * 238.846 }),
            UnitDef(name: "кВт\u{00B7}ч/м\u{00B3}", toBase: { $0 / 3.6 }, fromBase: { $0 * 3.6 }),
            UnitDef(name: "MJ/kg", toBase: { $0 * 1.0 }, fromBase: { $0 * 1.0 })
        ]),
        // 11: Объёмный расход (base: м³/ч)
        UnitGroup(name: "Объёмный расход", units: [
            UnitDef(name: "м\u{00B3}/ч", toBase: { $0 }, fromBase: { $0 }),
            UnitDef(name: "л/с", toBase: { $0 * 3.6 }, fromBase: { $0 / 3.6 }),
            UnitDef(name: "л/мин", toBase: { $0 * 0.06 }, fromBase: { $0 / 0.06 }),
            UnitDef(name: "GPM", toBase: { $0 * 0.227125 }, fromBase: { $0 / 0.227125 })
        ])
    ]
}
