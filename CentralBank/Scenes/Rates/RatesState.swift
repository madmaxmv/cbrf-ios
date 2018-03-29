//
//  ExchangeRatesState.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

final class RatesState: State {
    /// ViewState экрана с курсом валют.
    var viewState: RatesViewState = .initial

    /// Все курсы валют.
    var ratesResult: RatesResult? = nil
}

extension RatesState {
    enum Event {
        case ratesResult(RatesResult)
    }
}

extension RatesState {
    func reduce(event: RatesState.Event) {
        switch event {
        case .ratesResult(let result):
            self.ratesResult = result
            
            switch result {
            case .success(let rates),
                 .today(let rates, _),
                 .yesterday(let rates, _):
                self.viewState.content = RatesTableSection.makeContent(for: rates)
            default: break
            }
        }
    }
}


extension RatesState {
    var queryAcquireRates: Void? {
        return (ratesResult == nil) ? () : nil
    }
}

