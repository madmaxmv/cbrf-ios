//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Nivelir

final class RatesEffects {

    let effects: Effects<RatesState, RatesEvent>

    init(
        screens: AppScreens,
        services: AppServices
    ) {
        effects = { state, event in
            switch event {
            case .initial:
                return services.ratesProvider
                    .rates(on: Date())
                    .map { .ratesResult(.success($0)) }
                    .replaceError(
                        with: .ratesResult(.failure(.responseFailed))
                    )
                    .eraseToAnyPublisher()
            case .openRate:
                guard let rate = state.rateToOpen else {
                    return nil
                }
                services.screenNavigator
                    .navigate(fromTop: .modalContainer) { route in
                        route.present(
                            screens.currencyRateScreen(rate: rate),
                            animated: true
                        )
                    }
            default:
                break
            }
            return nil
        }
    }
}
