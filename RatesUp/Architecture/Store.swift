//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import Combine
import Foundation

typealias Reducer<State, Event> = (inout State, Event) -> Void
typealias Effects<State, Event> = (State, Event) -> AnyPublisher<Event, Never>?

final class Store<State, Event> {
    var state: CurrentValueSubject<State, Never>

    private let reducer: Reducer<State, Event>
    private let effects: Effects<State, Event>
    private var subscriptions = Set<AnyCancellable>()

    init(initial: State,
         reducer: @escaping Reducer<State, Event>,
         effects: @escaping Effects<State, Event>) {
        self.state = CurrentValueSubject(initial)
        self.reducer = reducer
        self.effects = effects
    }

    func send(_ event: Event) {
        var current = state.value
        reducer(&current, event)

        effects(current, event)?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.send(event)
            }
            .store(in: &subscriptions)

        state.send(current)
    }
}

