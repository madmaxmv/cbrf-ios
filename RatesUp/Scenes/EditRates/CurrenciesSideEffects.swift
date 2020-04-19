//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxFeedback

struct CurrenciesSideEffects {
    private let _services: AppServices
    private let _coordinator: SceneCoordinator
    
    init(services: AppServices, coordinator: SceneCoordinator) {
        _services = services
        _coordinator = coordinator
    }
    
    var effects: [SideEffects.ScheduledEffect] {
        return [
            react(request: { $0.rates.edit?.queryLoadCurrencies }, effects: loadCurrencies)
        ]
    }
    
    var loadCurrencies: (Bool) -> Observable<SideEffects.State.Event> {
        return { _ in
            self._services.ratesService
                .currencies()
                .map { .rates(.edit(.currencies($0))) }
        }
    }
}
