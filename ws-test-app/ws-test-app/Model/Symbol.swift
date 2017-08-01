//
//  Symbol.swift
//  ws-test-app
//
//  Created by Dmitry Osipa on 8/1/17.
//  Copyright © 2017 Dmitry Osipa. All rights reserved.
//

import Foundation

enum Symbol: String {

    case EURUSD = "EURUSD"
    case EURGBP = "EURGBP"
    case USDJPY = "USDJPY"
    case GBPUSD = "GBPUSD"
    case USDCHF = "USDCHF"
    case USDCAD = "USDCAD"
    case AUDUSD = "AUDUSD"
    case EURJPY = "EURJPY"
    case EURCHF = "EURCHF"

    static let allValues: Set<Symbol> = Set([.EURUSD, .EURGBP, .USDJPY, .GBPUSD, .USDCHF, .USDCAD, .AUDUSD, .EURJPY, .EURCHF])
}
