//
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
        case refreshRates
    }
}

extension RatesState {
    func reduce(event: RatesState.Event) {
        switch event {
        case .ratesResult(let result):
            ratesResult = result
            
            switch result {
            case .success(let rates),
                 .today(let rates, _),
                 .yesterday(let rates, _):
                viewState.isLoading = false
                viewState.content = RatesTableSection.makeContent(for: rates)
            default: break
            }
        case .refreshRates:
            viewState.isLoading = true
            ratesResult = nil
        }
    }
}


extension RatesState {
    var queryAcquireRates: Void? {
        return (ratesResult == nil) ? () : nil
    }
}

