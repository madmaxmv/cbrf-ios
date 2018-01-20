//
//  ExchangeRatesViewState.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesViewState {

    static var initial: RatesViewState {
        return RatesViewState()
    }
}


extension RatesViewState: Equatable {
    public static func == (lhs: RatesViewState, rhs: RatesViewState) -> Bool {
        return true
    }
}
