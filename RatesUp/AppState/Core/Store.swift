//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import Combine
import Foundation

final class Store<State, Event, Environment> {
    var state: CurrentValueSubject<State, Never>
    private let reducer: Reducer<State, Event, Environment>
    private let environment: Environment
    private var subscriptions = Set<AnyCancellable>()

    init(initial: State,
         reducer: @escaping Reducer<State, Event, Environment>,
         environment: Environment) {
        self.state = CurrentValueSubject(initial)
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ event: Event) {
        var current = state.value
        let effects = reducer(&current, event)
        effects.forEach { effect in
            effect.run(in: environment)
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in print(completion) },
                    receiveValue: { [weak self] event in self?.send(event) }
                )
                .store(in: &subscriptions)
        }
        state.send(current)
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
