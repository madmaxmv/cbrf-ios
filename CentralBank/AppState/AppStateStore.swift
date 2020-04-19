//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback

struct AppStateStore {

    let eventBus: PublishSubject<AppState.Event>
    let stateBus: Driver<AppState>

    private let bag = DisposeBag()

    init(sideEffects: AppSideEffects, scheduler: SchedulerType = MainScheduler.instance) {

        let _eventBus = PublishSubject<AppState.Event>()
        eventBus = _eventBus
        let eventBusFeedback: AppSideEffects.ScheduledEffect = { observableContext -> Observable<AppState.Event> in
            _eventBus.observeOn(observableContext.scheduler)
        }

        var feedBacks = sideEffects.effects
        feedBacks.append(eventBusFeedback)

        stateBus = Observable.system(initialState: AppState.initial,
                                     reduce: AppState.reduce,
                                     scheduler: scheduler,
                                     feedback: feedBacks)
            .assertError()
            .asDriver(onErrorDriveWith: .never())
    }

    func run() {
        stateBus.drive()
            .disposed(by: bag)
    }
}
