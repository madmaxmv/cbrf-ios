//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Nivelir

final class RatesEnvironment {
    let fetchRates: (Date) -> Promise<ExchangeRates, Error>
    let navigateToRate: (CurrencyRate) -> Void
    
    init(
        screens: AppScreens,
        services: AppServices
    ) {
        fetchRates = { date in
            services.ratesService.rates(on: date).asPromise()
        }

        navigateToRate = { (rate: CurrencyRate) -> Void in
            services.screenNavigator
                .navigate(fromTop: .modalContainer) { route in
                    route.present(
                        screens.currencyRateScreen(rate: rate),
                        animated: true
                    )
                }
        }
    }
}
