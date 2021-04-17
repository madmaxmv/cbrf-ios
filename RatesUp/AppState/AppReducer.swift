//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

typealias AppReducer = Reducer<AppState, AppState.Event, AppEnvironment>

extension AppState {
    static let reducer: AppReducer = { state, event in
        switch event {
        case .rates(let event):
            return RatesState.reducer(&state.rates, event)
                .map { $0.mapEvent { .rates($0) } }
        }
    }
}
