//
//  QuoteTableViewController.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import UIKit

class QuoteTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    private let popoverSegue = "popoverSettings"
    private let settings = Settings()
    private var dataSource: QuoteDataSource!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == popoverSegue) {
            let popoverViewController = segue.destination as! SettingsTableViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.settings = self.settings
        }
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = QuoteDataSource(table: self.tableView, aSettings: self.settings)
        tableView.dataSource = dataSource
        dataSource.update()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        dataSource.update()
        settings.save()
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row < dataSource.sortedItems.count {
            return proposedDestinationIndexPath
        } else {
            return sourceIndexPath
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.dataSource.pause = editing
    }
}
