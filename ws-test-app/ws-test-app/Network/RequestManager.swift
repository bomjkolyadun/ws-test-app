//
//  RequestManager.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import UIKit
import SwiftWebSocket

typealias UpdateBlock = (_ data: Data) -> Void

class RequestManager: NSObject {

    let ws = WebSocket("wss://quotes.exness.com:18400")
    var updateBlock: UpdateBlock? = nil

    func webSocketError(_ error: NSError) {
        print("ws error: \(error)")
    }

    override init() {
        super.init()
        ws.open()
        ws.event.message = { (object) in
            guard let string = (object as? String)
                else { return }
            guard let data = string.data(using: String.Encoding.utf8)
                else { return }
            self.updateBlock?(data)
        }
    }

    deinit {
        ws.close();
    }

    func subscribe(symbols: Set<Symbol>) {
        let values = symbols.map { $0.rawValue }
        let message = "SUBSCRIBE: " + values.joined(separator: ",")
        ws.send(message)
    }

    func unsubscribe(symbols: Set<Symbol>) {
        let values = symbols.map { $0.rawValue }
        let message = "UNSUBSCRIBE: " + values.joined(separator: ",")
        ws.send(message)
    }

}
