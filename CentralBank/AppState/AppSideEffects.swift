//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback

struct AppSideEffects {

    private let _coordinator: SceneCoordinator
    private let _backgroundScheduler: SchedulerType
    
    private let _services: AppServices
    
    private let _rates: RatesSideEffects

    init(coordinator: SceneCoordinator,
         services: AppServices,
         backgroundScheduler: SchedulerType) {
        
        _coordinator = coordinator
        _backgroundScheduler = backgroundScheduler
        
        _services = services
        
        _rates = RatesSideEffectsImpl(services: _services,
                                      backgroundScheduler: backgroundScheduler)
    }
}

// MARK: - SideEffects
extension AppSideEffects: SideEffects {
    typealias State = AppState
    typealias ScheduledEffect = (ObservableSchedulerContext<State>) -> Observable<State.Event>

    var effects: [ScheduledEffect] {
        var effects: [ScheduledEffect] = []
        effects.append(contentsOf: _rates.effects)
        return effects
    }
}
