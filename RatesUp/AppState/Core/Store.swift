//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import RxSwift

typealias Reducer<State, Event, Environment>
    = (inout State, Event) -> [Effect<Event, Environment>]

final class Store<State, Event, Environment> {
    var state: BehaviorSubject<State>
    private let reducer: Reducer<State, Event, Environment>
    private let environment: Environment
    private let bag = DisposeBag()

    init(initial: State,
         reducer: @escaping Reducer<State, Event, Environment>,
         environment: Environment) {
        self.state = BehaviorSubject(
            value: initial
        )
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ event: Event) {
        do {
            var current = try state.value()
            let effects = reducer(&current, event)
            effects.forEach { effect in
                effect.run(in: environment).subscribe(
                    onNext: { [weak self] event in self?.send(event) }
                ).disposed(by: bag)
            }
            state.onNext(current)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

func combine<State, Event, Environment>(
    _ reducers: Reducer<State, Event, Environment>...
) -> Reducer<State, Event, Environment> {
    return { state, event in
        reducers.reduce(into: []) { result, reducer in
            result.append(contentsOf: reducer(&state, event))
        }
    }
}
