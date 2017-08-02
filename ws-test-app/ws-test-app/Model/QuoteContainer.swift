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

fileprivate class QuotePool {

    var ticks: [Symbol: Quote] = [:]
    var tickArray: [Symbol]  = []

    init() {
        ticks = defaultTicks()
        let defaults = UserDefaults.standard
        let serializeArray = (Array(Symbol.allValues).map({ (sym: Symbol) -> String in
            return sym.rawValue
        }))
        defaults.register(defaults: ["sortOrderKey": serializeArray])
        let rawArray = defaults.array(forKey: "sortOrderKey")
        for key in rawArray! {
            let tick = Symbol(rawValue: key as! String)!
            tickArray.append(tick)
        }
    }

    func quote(sym: Symbol) -> Quote {
        return ticks[sym]!
    }

    private func defaultTicks() -> [Symbol: Quote] {
        var result: [Symbol: Quote] = [:]
        for sym in Symbol.allValues {
            let quote = Quote(sym: sym.rawValue)
            result[sym] = quote
        }
        return result
    }
}

class QuoteContainer: NSObject {

    static let updatedSymbolsKey = "updatedSymbols"

    private(set) var items: [Quote] = []

    private let quotePool = QuotePool()
    private let requestManager: RequestManager = { () -> RequestManager in
        let manager = RequestManager()
        return manager
    }()

    override init() {
        super.init()
        items = rebuildItems()
        requestManager.updateBlock = { (_ data: Data) -> Void in
            let response = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            var list: [String: Any]
            if let subscribed_list = (response["subscribed_list"] as? [String: Any]) {
                list = subscribed_list
            } else {
                list = response
            }
            guard let ticks = (list["ticks"] as? [[String: Any]]) else { return }
            var updatedSymbols: [Quote] = []
            for tick in ticks {
                guard let sym = (tick["s"] as? String),
                    let ask = (tick["a"] as? String),
                    let bid = (tick["b"] as? String),
                    let spr = (tick["spr"] as? String) else {
                        return
                }
                let key = Symbol(rawValue: sym)!
                let quote = self.quotePool.quote(sym: key)
                updatedSymbols.append(quote)
                quote.ask = ask
                quote.bid = bid
                quote.spread = spr
            }
            self.items = self.rebuildItems()
            NotificationCenter.default.post(name: .tickUpdateNotification, object: self, userInfo: [QuoteContainer.updatedSymbolsKey : updatedSymbols])
        }
    }

    func subscribe(symbols: Set<Symbol>) {
        requestManager.subscribe(symbols: symbols)
        for sym in symbols {
            quotePool.quote(sym: sym).hidden = false
        }
    }

    func unsubscribe(symbols: Set<Symbol>) {
        requestManager.unsubscribe(symbols: symbols)
        for sym in symbols {
            quotePool.quote(sym: sym).hidden = true
        }
    }

    func move(from: Int, to: Int) {
        let val1 = Symbol(rawValue: (items[from]).symbol)!
        let val2 = Symbol(rawValue: (items[to]).symbol)!
        let indexOfFirst = quotePool.tickArray.index(of: val1)!
        quotePool.tickArray.remove(at: indexOfFirst)
        let indexOfSecond = quotePool.tickArray.index(of: val2)!
        quotePool.tickArray.insert(val1, at: indexOfSecond+1)
        let serializeArray = (quotePool.tickArray.map({ (sym: Symbol) -> String in
            return sym.rawValue
        }))
        let defaults = UserDefaults.standard
        defaults.set(serializeArray, forKey: "sortOrderKey")
        defaults.synchronize()
        items = rebuildItems()
        NotificationCenter.default.post(name: .tickUpdateNotification, object: self)
    }

    private func rebuildItems() -> [Quote] {
        let result =  quotePool.tickArray.map({ (sym) -> Quote in
            quotePool.quote(sym: sym)
        }).filter { (quote) -> Bool in
            quote.hidden == false
        }
        return result
    }


}
