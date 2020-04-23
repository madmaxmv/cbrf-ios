//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import RxSwift

final class Store<State, Event, Environment> {
    typealias Reducer = (inout State, Event) -> [Effect<Event, Environment>]
    
    var state: BehaviorSubject<State>
    private let reducer: Reducer
    private let environment: Environment
    private let bag = DisposeBag()

    init(initial: State,
         reducer: @escaping Reducer,
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
                    onNext: { [weak self] event in self?.send(event) },
                    onError: { assertionFailure($0.localizedDescription) }
                ).disposed(by: bag)
            }
            state.onNext(current)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

func combine<State, Action, Environment>(
    _ reducers: Store<State, Action, Environment>.Reducer...
) -> Store<State, Action, Environment>.Reducer {
    return { state, action in
        reducers.reduce(into: []) { result, reducer in
            result.append(contentsOf: reducer(&state, action))
        }
    }
}
