//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct AppState {
    /// Стейт таб-бара.
    var tabBarState = TabBarViewState.initial
    
    /// Стейт экрана с курсом валют.
    var exchangeRates = RatesState()
}

// MARK: - State
extension AppState {

    enum Event {
    }

    static let initial = AppState()

    static func reduce(state: AppState, event: AppState.Event) -> AppState {
        debugPrint(event)
        return state
    }
}

// MARK: - Query
extension AppState {
}
