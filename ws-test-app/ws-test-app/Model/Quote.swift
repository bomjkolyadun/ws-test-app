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
    public var bid: String = ""
    public var ask: String = ""
    public var spread: String = ""
    public var hidden: Bool = false

    init(sym: String) {
        symbol = sym
        super.init()
    }
}
