//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import Foundation

final class AppEnvironment {
    let fetchRates: (Date) -> Promise<RatesResult, Error>

    init(services: AppServices) {
        fetchRates = { date in
            services.ratesService.rates(on: date).asPromise()
        }
    }
}
