//
//  SettingsDataSource.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import UIKit

class SettingsDataSource: NSObject, UITableViewDataSource {

    private let cellId = "SymbolCell"

    private var settings: Settings!

    init(settings: Settings) {
        super.init()
        self.settings = settings
    }

    // MARK: TableView Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.symsets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let setting = self.settings.symsets[indexPath.row]
        cell.textLabel?.text = setting.symbol.rawValue
        cell.accessoryType = setting.selected ? .checkmark : .none
        cell.selectionStyle = .none
        return cell
    }

    // MARK: Public API

    open func toggleItemAtIndexPath(indexPath: IndexPath, tableView: UITableView) {
        let item = self.settings.symsets[indexPath.row]
        item.selected = !item.selected
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
    
}
