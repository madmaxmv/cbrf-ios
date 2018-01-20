//
//  Copyright © 2017 Tutu.tu. All rights reserved.
//

import Foundation

struct AppState {
    /// Стейт таб-бара.
    var tabBarState = TabBarViewState.initial
    
    /// Стейт экрана с курсом валют.
    var exchangeRates = ExchangeRatesState()
}

// MARK: - State
extension AppState: State {

    enum Event {
    }

    static let initial = AppState()

    //swiftlint:disable cyclomatic_complexity function_body_length
    static func reduce(state: AppState, event: AppState.Event) -> AppState {

        debugPrint(event)

        return state
    }
}

// MARK: - Query
extension AppState {
}
