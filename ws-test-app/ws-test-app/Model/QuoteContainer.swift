//
//  QuoteContainer.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import UIKit

public extension NSNotification.Name {
    static let tickUpdateNotification = Notification.Name("tickUpdate")
}


class QuoteContainer: NSObject {

    let requestManager: RequestManager = { () -> RequestManager in
        let manager = RequestManager()
        return manager
    }()

    private var ticks: [Symbol : Quote] = [:]

    override init() {
        super.init()
        requestManager.updateBlock = { (_ data: Data) -> Void in
            let response = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            var list: [String: Any]
            if let subscribed_list = (response["subscribed_list"] as? [String: Any]) {
                list = subscribed_list
            } else {
                list = response
            }
            guard let ticks = (list["ticks"] as? [[String: Any]]) else { return }

            for tick in ticks {
                guard let sym = (tick["s"] as? String),
                      let ask = (tick["a"] as? String),
                      let bid = (tick["b"] as? String),
                      let spr = (tick["spr"] as? String) else {
                        return
                }
                let quote = Quote(sym: sym, b: bid, a: ask, spr: spr)
                let key = Symbol(rawValue: sym)
                self.ticks[key!] = quote
            }
            NotificationCenter.default.post(name: .tickUpdateNotification, object: self)
        }
    }

    func subscribe(sym: Set<Symbol>) {
        requestManager.subscribe(symbols: sym)
    }

    func unsubscribe(sym: Set<Symbol>) {
        requestManager.unsubscribe(symbols: sym)
        for symbol in sym {
            ticks.removeValue(forKey: symbol)
        }
    }

    func items() -> [Quote] {
        return Array(ticks.values)
    }
}
