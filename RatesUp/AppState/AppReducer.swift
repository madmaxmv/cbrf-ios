//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

extension AppState {
    static let reducer: AppStore.Reducer = { state, event in
        switch event {
        case .rates(let event):
            state.rates.reduce(event: event)
        }
        return []
    }
}
