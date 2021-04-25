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

    let currencyRate: CurrencyDailyRate
    let dynamics: [Int]?
}

enum CurrencyRateEvent {
    case loadDynamics
}

struct CurrencyRateEnvironment {
    
}
