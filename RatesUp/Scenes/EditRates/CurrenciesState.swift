//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

final class CurrenciesState {
    /// ViewState экрана с курсом валют.
    var viewState: CurrenciesViewState = .initial

    /// Признак того, что необходимо загрузить список валют.
    var shouldLoadCurrencies = true
    /// Список валют.
    var currencies: [Currency] = []
}

extension CurrenciesState {
    enum Event {
        case currencies([Currency])
        case saveChanges
    }
}

extension CurrenciesState {
    func reduce(event: Event) {
        switch event {
        case .currencies(let currencies):
            shouldLoadCurrencies = false
            self.currencies = currencies
            viewState.set(currencies: currencies)
        case .saveChanges: break
        }
    }
}

extension CurrenciesState {
    var queryLoadCurrencies: Bool? {
        return shouldLoadCurrencies ? true : nil
    }
}
