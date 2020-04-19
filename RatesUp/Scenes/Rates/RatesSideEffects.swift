//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxFeedback

extension RatesSideEffects {
    var effects: [SideEffects.ScheduledEffect] {
        return [
            react(request: { $0.rates.queryAcquireRates }, effects: acquireRates),
            react(request: { $0.rates.queryOpenEditMode }, effects: openEditMode),
            react(request: { $0.rates.queryCloseEditMode }, effects: closeEditMode)
        ]
    }
}

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
    
    var acquireRates: (Bool) -> Observable<SideEffects.State.Event> {
        return { _ in
            self._services.ratesService
                .rates(on: Date())
                .map { .rates(.ratesResult($0)) }
                .subscribeOn(self._backgroundScheduler)
        }
    }
    
    var openEditMode: (Bool) -> Observable<SideEffects.State.Event> {
        return { _ in self._coordinator
            .transition(to: .editRates, type: .modal(animated: true))
            .map { .rates(.editModeOpened) }
        }
    }
    
    var closeEditMode: (Bool) -> Observable<SideEffects.State.Event> {
        return { _ in
            self._coordinator.pop(animated: true)
                .map { .rates(.editModeClosed) }
        }
    }
}

