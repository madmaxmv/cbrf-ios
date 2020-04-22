//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

typealias AppStore = Store<AppState, AppState.Event>

let stateStore = AppStore(
    initial: AppState.initial,
    reducer: AppState.reducer
)
