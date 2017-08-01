//
//  QuoteDataSource.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import UIKit

class QuoteDataSource: NSObject, UITableViewDataSource {

    static let reuseId = "QuoteCell"
    let container = QuoteContainer()
    var sortedItems: [Quote] = []
    var settings: Settings
    weak var table: UITableView?

    var pause: Bool = false

    init(table tbl: UITableView, aSettings: Settings) {
        settings = aSettings
        super.init()
        table = tbl
        NotificationCenter.default.addObserver(forName: .tickUpdateNotification, object: container, queue: OperationQueue.main ) { _ in
            self.sortedItems = self.container.items()
            if self.pause {
                return
            }
            self.table?.beginUpdates()
            self.table?.reloadSections(IndexSet(integer: 0), with: .none)
            self.table?.endUpdates()
        }
    }

    func update() {
        container.unsubscribe(symbols: settings.disabledSymbols())
        container.subscribe(symbols: settings.enabledSymbols())
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuoteDataSource.reuseId, for: indexPath) as! QuoteCell
        cell.setup(tick: sortedItems[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.row == destinationIndexPath.row {
            return
        } else {

            tableView.beginUpdates()
            self.container.move(from: sourceIndexPath.row , to: destinationIndexPath.row)
            tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            tableView.endUpdates()
        }
    }

}
