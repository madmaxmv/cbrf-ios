//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

struct AppState {
    var rates = RatesState()
}

extension AppState {
    enum Event {
        case rates(RatesState.Event)
    }
}

extension AppState {
    static let initial = AppState()
}
