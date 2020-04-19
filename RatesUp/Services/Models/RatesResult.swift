//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

enum RatesResult {
    case success(rates: [CurrencyDailyRate])
    case today(rates: [CurrencyDailyRate], error: RatesError)
    case yesterday(rates: [CurrencyDailyRate], error: RatesError)
    case failed(error: RatesError)
}
