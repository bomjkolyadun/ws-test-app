//
//  QuoteCell.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var bidAskLabel: UILabel!
    @IBOutlet weak var spreadLabel: UILabel!

    func setup(tick: Quote) {
        var symbol = tick.symbol
        symbol.insert("/", at: symbol.index(symbol.startIndex, offsetBy: 3))
        symbolLabel.text =  symbol
        bidAskLabel.text = tick.bid + "/" + tick.ask
        spreadLabel.text = tick.spread
    }

}
