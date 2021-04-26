//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

typealias RatesResult = Result<DailyRates, RatesError>

struct DailyRates: Equatable {

    let rates: [CurrencyRate]
}
