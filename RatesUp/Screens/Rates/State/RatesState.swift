//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

typealias RatesStateStore = Store<RatesState, RatesEvent>

struct RatesState: Equatable {

    var isLoading: Bool = false
    var ratesResult: ExchangeRatesResult?
    var rateToOpen: CurrencyRate?

    static let initial = RatesState()
}

enum RatesEvent {
    case initial
    case ratesResult(ExchangeRatesResult)
    case openRate(withID: String)
}

extension RatesState {

    static let reducer: Reducer<RatesState, RatesEvent> = { state, event in
        switch event {
        case .initial:
            state.isLoading = true
        case .ratesResult(let result):
            state.isLoading = false
            state.ratesResult = result
        case .openRate(let id):
            guard case let .success(dailyRates) = state.ratesResult else {
                return
            }
            state.rateToOpen = dailyRates.rates
                .first { $0.id == id }
        }
    }
}
