//
//  ExchangeRatesViewState.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct ExchangeRatesViewState {
    
    static var initial: ExchangeRatesViewState {
        return ExchangeRatesViewState()
    }
}


extension ExchangeRatesViewState: Equatable {
    public static func == (lhs: ExchangeRatesViewState, rhs: ExchangeRatesViewState) -> Bool {
        return true
    }
}
