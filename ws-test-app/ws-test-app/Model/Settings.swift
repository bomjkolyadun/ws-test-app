//
//  Settings.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import UIKit

class SymbolSetting {
    var symbol: Symbol
    var selected: Bool
    init(symbol aSymbol: Symbol, selected isSelected: Bool) {
        symbol = aSymbol
        selected = isSelected
    }
}

class Settings: NSObject {

    private(set) var symsets: [SymbolSetting]!

    override init() {
        super.init()
        symsets = symFromDefaults()
    }

    static func defaults() -> [String: Any] {
        var dict: [String: Any] = [:]
        for sym in Symbol.allValues {
            dict[sym.rawValue] = true
        }
        return dict
    }

    private func symFromDefaults() -> [SymbolSetting] {
        let defaults = UserDefaults.standard
        defaults.register(defaults: Settings.defaults())
        var settings: [SymbolSetting] = []
        for sym in Symbol.allValues {
            let val = defaults.bool(forKey: sym.rawValue)
            let symset = SymbolSetting(symbol: sym, selected: val)
            settings.append(symset)
        }
        return settings
    }

    func save() {
        let defaults = UserDefaults.standard
        for setting in symsets {
            defaults.set(setting.selected, forKey: setting.symbol.rawValue)
        }
    }

    func enabledSymbols() -> Set<Symbol> {
        let options = Set((symsets.filter { $0.selected }).map { $0.symbol })
        return options
    }

    func disabledSymbols() -> Set<Symbol> {
        let options = Symbol.allValues.subtracting(enabledSymbols())
        return options
    }
}
