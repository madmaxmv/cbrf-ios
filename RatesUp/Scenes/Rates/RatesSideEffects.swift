//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift

struct RatesSideEffects {
    
    private let _services: AppServices
    private let _coordinator: SceneCoordinator
    private let _backgroundScheduler: SchedulerType
    
    
    init(services: AppServices,
         coordinator: SceneCoordinator,
         backgroundScheduler: SchedulerType) {
        _services = services
        _coordinator = coordinator
        _backgroundScheduler = backgroundScheduler
    }

    var effects: [AppSideEffect] {
        return [
//            react(request: { $0.rates.queryAcquireRates }, effects: acquireRates),
//            react(request: { $0.rates.queryOpenEditMode }, effects: openEditMode),
//            react(request: { $0.rates.queryCloseEditMode }, effects: closeEditMode)
        ]
    }

    var acquireRates: (Bool) -> Observable<AppState.Event> {
        return { _ in
            self._services.ratesService
                .rates(on: Date())
                .map { .rates(.ratesResult($0)) }
                .subscribeOn(self._backgroundScheduler)
        }
    }
    
    var openEditMode: (Bool) -> Observable<AppState.Event> {
        return { _ in self._coordinator
            .transition(to: .editRates, type: .modal(animated: true))
            .map { .rates(.editModeOpened) }
        }
    }
    
    var closeEditMode: (Bool) -> Observable<AppState.Event> {
        return { _ in
            self._coordinator.pop(animated: true)
                .map { .rates(.editModeClosed) }
        }
    }
}

