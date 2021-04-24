//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import Foundation

final class AppEnvironment {
    let services: AppServices
    let fetchRates: (Date) -> Promise<DailyRates, Error>

    init(services: AppServices) {
        self.services = services

        fetchRates = { date in
            services.ratesService.rates(on: date).asPromise()
        }
    }
}
