//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

typealias RatesStateStore = Store<
    RatesState,
    RatesEvent,
    RatesEnvironment
>

struct RatesState: Equatable {

    var isLoading: Bool = false
    var ratesResult: ExchangeRatesResult?

    static let initial = RatesState()
}

enum RatesEvent {
    case initial
    case ratesResult(ExchangeRatesResult)
    case openRate(withID: String)
    case nothing
}
