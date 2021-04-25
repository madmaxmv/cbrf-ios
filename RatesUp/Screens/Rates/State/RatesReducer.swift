//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import Foundation

typealias RatesReducer = Reducer<
    RatesState,
    RatesEvent,
    RatesEnvironment
>

extension RatesState {
    static let reducer: RatesReducer = { state, event in
        switch event {
        case .initial:
            return [fetchRatesEffect]
        case .ratesResult(let result):
            state.ratesResult = result
        default: break
        }

        return []
    }
}

private extension RatesState {
    static let fetchRatesEffect = Effect<RatesEvent, RatesEnvironment> { env in
        env.fetchRates(Date())
            .map { .ratesResult(.success($0)) }
    }
}
