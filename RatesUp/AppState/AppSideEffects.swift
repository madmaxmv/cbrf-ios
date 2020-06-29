//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift

typealias AppSideEffect = (AppState) -> Observable<AppState.Event>

struct AppSideEffects {

    private let _backgroundScheduler: SchedulerType
    
    private let _services: AppServices
    
    private let _rates: RatesSideEffects
    private let _currencies: CurrenciesSideEffects

    init(services: AppServices,
         backgroundScheduler: SchedulerType) {
        _backgroundScheduler = backgroundScheduler
        
        _services = services
        
        _rates = RatesSideEffects(services: _services,
                                  backgroundScheduler: backgroundScheduler)

        _currencies = CurrenciesSideEffects(services: _services)
    }
}

// MARK: - SideEffects
extension AppSideEffects {
    var effects: [AppSideEffect] {
        var effects: [AppSideEffect] = []
        effects.append(contentsOf: _rates.effects)
        effects.append(contentsOf: _currencies.effects)
        return effects
    }
}
