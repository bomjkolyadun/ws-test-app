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

    init(table tbl: UITableView, aSettings: Settings) {
        settings = aSettings
        super.init()
        table = tbl
        NotificationCenter.default.addObserver(forName: .tickUpdateNotification, object: container, queue: OperationQueue.main ) { _ in
            self.sortedItems = self.container.items().sorted(by: {
                 guard let val1 = self.settings.sortOrder[$0.symbol],
                    let val2 = self.settings.sortOrder[$1.symbol] else {
                        return false
                }
                return val1 < val2
            })
            self.table?.beginUpdates()
            self.table?.reloadSections(IndexSet(integer: 0), with: .none)
            self.table?.endUpdates()
        }
    }

    func update() {
        container.unsubscribe(sym: settings.disabledSymbols())
        container.subscribe(sym: settings.enabledSymbols())
    }

    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedItems.count
    }

    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuoteDataSource.reuseId, for: indexPath) as! QuoteCell
        cell.setup(tick: sortedItems[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

}
