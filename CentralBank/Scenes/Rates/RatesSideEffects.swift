//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxFeedback

protocol RatesSideEffects: SideEffects {
    /// Получение курсов валют.
    var acquireRates: () -> Observable<SideEffects.State.Event> { get }
}

extension RatesSideEffects {
    var effects: [SideEffects.ScheduledEffect] {
        return [
            react(query: { $0.rates.queryAcquireRates }, effects: acquireRates)
        ]
    }
}

struct RatesSideEffectsImpl: RatesSideEffects {
    
    private let _services: AppServices
    private let _backgroundScheduler: SchedulerType
    
    
    init(services: AppServices,
         backgroundScheduler: SchedulerType) {
        _services = services
        _backgroundScheduler = backgroundScheduler
    }
    
    var acquireRates: () -> Observable<SideEffects.State.Event> {
        return {
            self._services.ratesService
                .rates(on: Date())
                .map { .rates(.ratesResult($0)) }
                .subscribeOn(self._backgroundScheduler)
        }
    }
}

