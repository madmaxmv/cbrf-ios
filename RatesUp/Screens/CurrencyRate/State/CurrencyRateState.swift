//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

typealias CurrencyRateStore = Store<
    CurrencyRateState,
    CurrencyRateEvent,
    CurrencyRateEnvironment
>

struct CurrencyRateState {

    let currencyRate: CurrencyRate
    var dynamics: RateDynamicsResult? = nil
}

enum CurrencyRateEvent {
    case loadDynamics
    case dynamicsResult(RateDynamicsResult)
}

typealias CurrencyRateReducer = Reducer<
    CurrencyRateState,
    CurrencyRateEvent,
    CurrencyRateEnvironment
>

extension CurrencyRateState {
    static let reducer: CurrencyRateReducer = { state, event in
        switch event {
        case .loadDynamics:
            return [
                fetchDynamics(id: state.currencyRate.id)
            ]
        case .dynamicsResult(let result):
            state.dynamics = result
        }
        return []
    }
}

extension CurrencyRateState {
    static func fetchDynamics(id: String) -> Effect<CurrencyRateEvent, CurrencyRateEnvironment> {
        return Effect { env in
            env.fetchDynamics(id)
                .map { .dynamicsResult(.success($0)) }
        }
    }
}

struct CurrencyRateEnvironment {

    let fetchDynamics: (String) -> Promise<RateDynamics, Error>

    init(dynamicsProvider: RateDynamicsProvider) {
        fetchDynamics = { currencyID in
            dynamicsProvider.dynamicsForCurrency(
                with: currencyID,
                dateRange: (
                    from: Date().addingTimeInterval(-60.0*60*24*30),
                    to: Date()
                )
            ).asPromise()
            
        }
    }
}
