//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Combine

final class CurrencyRateEffects {

    let effects: Effects<CurrencyRateState, CurrencyRateEvent>

    init(services: AppServices) {

        effects = { state, event in
            switch event {
            case .loadDynamics:
                return services.dynamicsProvider
                    .dynamicsForCurrency(
                        withID: state.currencyRate.id,
                        dateRange: (
                            from: Date().addingTimeInterval(-60*60*24*30),
                            to: Date()
                        )
                    )
                    .map { .dynamicsResult(.success($0)) }
                    .replaceError(
                        with: .dynamicsResult(.failure(.responseFailed))
                    )
                    .eraseToAnyPublisher()
            case .close:
                services.screenNavigator
                    .navigate(fromTop: .modalContainer) { route in
                        route.dismissScreen(animated: true)
                }
            default:
                break
            }
            return nil
        }
    }
}
