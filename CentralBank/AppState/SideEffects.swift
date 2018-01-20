//
//  Copyright © 2017 Tutu.tu. All rights reserved.
//

import RxSwift
import RxFeedback

protocol SideEffects {
    typealias State = AppState
    typealias ScheduledEffect = (ObservableSchedulerContext<State>) -> Observable<State.Event>

    var effects: [ScheduledEffect] { get }
}
