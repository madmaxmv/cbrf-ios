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
    let dynamics: [Int]? = nil
}

enum CurrencyRateEvent {
    case loadDynamics
}

typealias CurrencyRateReducer = Reducer<
    CurrencyRateState,
    CurrencyRateEvent,
    CurrencyRateEnvironment
>

extension CurrencyRateState {
    static let reducer: CurrencyRateReducer = { state, event in
        return []
    }
}

struct CurrencyRateEnvironment {
    
}
