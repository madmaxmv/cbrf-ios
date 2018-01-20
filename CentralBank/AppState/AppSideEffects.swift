//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback

struct AppSideEffects {

    private let _coordinator: SceneCoordinator
    private let _backgroundScheduler: SchedulerType

    init(coordinator: SceneCoordinator,
         backgroundScheduler: SchedulerType) {
        
        _coordinator = coordinator
        _backgroundScheduler = backgroundScheduler
    }
}

// MARK: - SideEffects
extension AppSideEffects: SideEffects {
    typealias State = AppState
    typealias ScheduledEffect = (ObservableSchedulerContext<State>) -> Observable<State.Event>

    var effects: [ScheduledEffect] {
        var effects: [ScheduledEffect] = []
        return effects
    }
}
