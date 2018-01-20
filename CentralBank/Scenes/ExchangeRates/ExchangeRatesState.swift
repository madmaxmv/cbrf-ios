//
//  ExchangeRatesState.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

final class ExchangeRatesState: State {
    /// ViewState экрана с курсом валют.
    var viewState: ExchangeRatesViewState = .initial
}

extension ExchangeRatesState {
    enum Event {
        
    }
}

extension ExchangeRatesState {
    static func reduce(state: ExchangeRatesState,
                       event: ExchangeRatesState.Event) -> ExchangeRatesState {
        return state
    }
}
