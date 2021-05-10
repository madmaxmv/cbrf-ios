//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Combine

typealias CurrencyRateStore = Store<CurrencyRateState, CurrencyRateEvent>

struct CurrencyRateState {

    let currencyRate: CurrencyRate
    var isLoading: Bool = false
    var dynamics: RateDynamicsResult? = nil
}

enum CurrencyRateEvent {
    case loadDynamics
    case dynamicsResult(RateDynamicsResult)
    case close
}

typealias CurrencyRateReducer = Reducer<
    CurrencyRateState,
    CurrencyRateEvent
>

extension CurrencyRateState {
    static let reducer: CurrencyRateReducer = { state, event in
        switch event {
        case .loadDynamics:
            state.isLoading = true
        case .dynamicsResult(let result):
            state.isLoading = false
            state.dynamics = result
        case .close:
            break
        }
    }
}
