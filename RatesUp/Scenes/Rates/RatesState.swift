//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesState: Equatable {

    var ratesResult: RatesResult?
}

extension RatesState {
    enum Event {
        case initial
        case ratesResult(RatesResult)
        case refreshRates
        case openEditMode
        case editModeOpened, editModeClosed
        case cancelEditing, editingDone
    }
}

extension RatesState {
    static let reducer: Reducer<RatesState, Event, AppEnvironment> = { state, event in
        switch event {
        case .initial:
            return [fetchRatesEffect]
        case .ratesResult(let result):
            state.ratesResult = result
        default: break
        }

        return []
    }
}

private extension RatesState {
    static let fetchRatesEffect = Effect<Event, AppEnvironment> { env in
        env.fetchRates(Date())
            .map { .ratesResult(.success($0)) }
    }
}
