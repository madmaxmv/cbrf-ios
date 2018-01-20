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

    /// Все курсы
    var rates: [RateModel] = []
}

extension RatesState {
    enum Event {
        case ratesAcquired([RateModel])
    }
}

extension RatesState {
    func reduce(event: RatesState.Event) {
        switch event {
        case .ratesAcquired(let rates):
            self.rates = rates
        }
    }
}


extension RatesState {
    var queryAcquireRates: Void? {
        return rates.isEmpty ? () : nil
    }
}

