//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

enum RatesResult: Equatable {
    case success(rates: [CurrencyDailyRate])
    case today(rates: [CurrencyDailyRate], error: RatesError)
    case yesterday(rates: [CurrencyDailyRate], error: RatesError)
    case failed(error: RatesError)

    var rates: [CurrencyDailyRate]? {
        switch self {
        case let .success(rates),
             let .today(rates, _),
             let .yesterday(rates, _):
            return rates
        case .failed:
            return nil
        }
    }
}
