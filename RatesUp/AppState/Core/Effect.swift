//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

struct Effect<Event, Environment> {
    var effect: (Environment) -> Promise<Event>
    init(effect: @escaping (Environment) -> Promise<Event>) {
        self.effect = effect
    }

    func run(in environment: Environment) -> Promise<Event> {
        effect(environment)
    }
}

import RxSwift

struct Promise<Event>: ObservableType {
    public typealias E = Event
    let observable: Observable<E>

    func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, Self.E == O.E {
        return observable.subscribe(observer)
    }
}

extension Promise {
    func map<R>(_ transform: @escaping (Event) throws -> R) -> Promise<R> {
        return observable.map(transform).asPromise()
    }
}

extension Observable {
    func asPromise() -> Promise<Element> {
        Promise(observable: self)
    }
}
