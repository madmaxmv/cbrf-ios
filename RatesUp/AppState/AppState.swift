//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct AppState {
    /// Стейт таб-бара.
    var tabBarState = TabBarViewState.initial
    
    /// Стейт экрана с курсом валют.
    var rates = RatesState()
}

// MARK: - State
extension AppState {

    enum Event {
        case rates(RatesState.Event)
    }

    static let initial = AppState()

    static func reduce(state: AppState, event: AppState.Event) -> AppState {
//        debugPrint(event)
        let _state = state
        switch event {
        case .rates(let event):
            _state.rates.reduce(event: event)
        }
        return _state
    }
}

// MARK: - Query
extension AppState {
}
