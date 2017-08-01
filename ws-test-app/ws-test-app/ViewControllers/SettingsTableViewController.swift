//
//  SettingsTableViewController.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import UIKit



class SettingsTableViewController: UITableViewController {

    var settings: Settings! {
        didSet {
            self.dataSource = SettingsDataSource(settings: settings)
        }
    }
    private var dataSource: SettingsDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSource.toggleItemAtIndexPath(indexPath: indexPath, tableView: tableView)
    }
}
