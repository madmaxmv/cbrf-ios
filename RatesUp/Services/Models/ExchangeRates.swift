//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

typealias ExchangeRatesResult = Result<ExchangeRates, RatesError>

struct ExchangeRates: Equatable {

    let rates: [CurrencyRate]
}
