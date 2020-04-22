//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

struct Effect<Event> {
    var effect: () -> Promise<Event>
    init(effect: @escaping () -> Promise<Event>) {
        self.effect = effect
    }

    func run() -> Promise<Event> { effect() }
}

import RxSwift

struct Promise<Event>: ObservableType {
    public typealias E = Event
    let observable: Observable<E>

    func subscribe<O>(_ observer: O) -> Disposable where O : ObserverType, Self.E == O.E {
        return observable.subscribe()
    }
}
