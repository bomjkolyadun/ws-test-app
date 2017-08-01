//
//  Quote.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import UIKit

class Quote: NSObject {

    private(set) public var symbol: String
    private(set) public var bid: String
    private(set) public var ask: String
    private(set) public var spread: String

    init(sym: String, b: String, a: String, spr: String) {
        symbol = sym
        bid = b
        ask = a
        spread = spr
        super.init()
    }
}
