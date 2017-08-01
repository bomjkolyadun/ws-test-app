//
//  SettingsDataSource.swift
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

class SettingsDataSource: NSObject, UITableViewDataSource {

    private let cellId = "SymbolCell"

    private var items: [SymbolSetting] = [SymbolSetting(symbol: .EURUSD, selected: true),
                                  SymbolSetting(symbol: .EURGBP, selected: true),
                                  SymbolSetting(symbol: .USDJPY, selected: true),
                                  SymbolSetting(symbol: .GBPUSD, selected: true),
                                  SymbolSetting(symbol: .USDCHF, selected: true),
                                  SymbolSetting(symbol: .USDCAD, selected: true),
                                  SymbolSetting(symbol: .AUDUSD, selected: true),
                                  SymbolSetting(symbol: .EURJPY, selected: true),
                                  SymbolSetting(symbol: .EURCHF, selected: true)]

    // MARK: TableView Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let setting = items[indexPath.row]
        cell.textLabel?.text = setting.symbol.rawValue
        cell.accessoryType = setting.selected ? .checkmark : .none
        cell.selectionStyle = .none
        return cell
    }

    // MARK: public API

    open func toggleItemAtIndexPath(indexPath: IndexPath, tableView: UITableView) {
        let item = items[indexPath.row]
        item.selected = !item.selected
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }

    func optionSet() -> [Symbol] {
        let options = (items.filter { $0.selected }).map { $0.symbol }
        return options
    }
    
}
