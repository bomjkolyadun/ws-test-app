//
//  SettingsTableViewController.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import UIKit

enum Symbol: String {
    case EURUSD = "EUR/USD"
    case EURGBP = "EUR/GBP"
    case USDJPY = "USD/JPU"
    case GBPUSD = "GBP/USD"
    case USDCHF = "USD/CHF"
    case USDCAD = "USD/CAD"
    case AUDUSD = "AUD/USD"
    case EURJPY = "EUR/JPY"
    case EURCHF = "EUR/CHF"
}

class SettingsTableViewController: UITableViewController {

    let dataSource = SettingsDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSource.toggleItemAtIndexPath(indexPath: indexPath, tableView: tableView)
    }
}
