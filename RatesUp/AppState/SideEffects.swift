//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxFeedback

protocol SideEffects {
    typealias State = AppState
    typealias ScheduledEffect = (ObservableSchedulerContext<State>) -> Observable<State.Event>

    var effects: [ScheduledEffect] { get }
}
