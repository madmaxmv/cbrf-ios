//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

struct Effect<Event, Environment> {
    var effect: (Environment) -> Promise<Event, Error>
    init(effect: @escaping (Environment) -> Promise<Event, Error>) {
        self.effect = effect
    }

    func run(in environment: Environment) -> Promise<Event, Error> {
        effect(environment).asPromise()
    }
}

extension Effect {
    func mapEvent<E>(_ transform: @escaping (Event) -> E) -> Effect<E, Environment> {
        return Effect<E, Environment> { env in
            return effect(env).map(transform)
        }
    }
}

import Combine

struct Promise<Output, Failure: Error>: Publisher {
    let upstream: AnyPublisher<Output, Failure>
    
    init<P: Publisher>(_ publisher: P) where P.Output == Output, P.Failure == Failure {
        self.upstream = publisher.eraseToAnyPublisher()
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        upstream.receive(subscriber: subscriber)
    }
}

extension Promise {
    func map<R>(_ transform: @escaping (Output) -> R) -> Promise<R, Failure> {
        Publishers.Map(upstream: upstream, transform: transform).asPromise()
    }
}

extension Publisher {
    func asPromise() -> Promise<Output, Failure> { Promise(self) }
}
