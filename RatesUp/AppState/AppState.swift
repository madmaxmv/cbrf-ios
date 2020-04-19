//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//


import ReSwift

struct AppState: StateType {
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

    static func reduce(action: Action, state: AppState?) -> AppState {
        let _state = state ?? .initial
//        switch action {
//        case .rates(let event):
//            _state.rates.reduce(event: event)
//        }
        return _state
    }
}

// MARK: - Query
extension AppState {
}
