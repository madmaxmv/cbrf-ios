//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxFeedback

protocol CurrenciesSideEffects {
    /// Получение списка валют.
    var loadCurrencies: () -> Observable<SideEffects.State.Event> { get }
}

extension CurrenciesSideEffects {
    var effects: [SideEffects.ScheduledEffect] {
        return [
            react(query: { $0.rates.edit?.queryLoadCurrencies }, effects: loadCurrencies)
        ]
    }
}

struct CurrenciesSideEffectsImpl: CurrenciesSideEffects {
    
    private let _services: AppServices
    private let _coordinator: SceneCoordinator
    
    init(services: AppServices, coordinator: SceneCoordinator) {
        _services = services
        _coordinator = coordinator
    }
    
    var loadCurrencies: () -> Observable<SideEffects.State.Event> {
        return {
            self._services.ratesService
                .currencies()
                .map { .rates(.edit(.currencies($0))) }
        }
    }
}
