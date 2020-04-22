//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift

struct CurrenciesSideEffects {
    private let _services: AppServices
    private let _coordinator: SceneCoordinator
    
    init(services: AppServices, coordinator: SceneCoordinator) {
        _services = services
        _coordinator = coordinator
    }
    
    var effects: [AppSideEffect] {
        return [
//            react(request: { $0.rates.edit?.queryLoadCurrencies }, effects: loadCurrencies)
        ]
    }
    
    var loadCurrencies: (Bool) -> Observable<AppState.Event> {
        return { _ in
            self._services.ratesService
                .currencies()
                .map { .rates(.edit(.currencies($0))) }
        }
    }
}
