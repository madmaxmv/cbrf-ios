//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesState: Equatable {
    var ratesResult: RatesResult? = nil
    // var editModeAction: SceneAction? = nil
    // var edit: CurrenciesState? = nil
}

extension RatesState {
    enum Event {
        case initial
        case ratesResult(RatesResult)
        case refreshRates
        case openEditMode
        case editModeOpened, editModeClosed
        case edit(CurrenciesState.Event)
        case cancelEditing, editingDone
    }
}

extension RatesState {
    static let reducer: Reducer<RatesState, AppState.Event, AppEnvironment> = { state, event in
        switch event {
        case .rates(.initial):
            return [fetchRatesEffect]
        case .rates(.ratesResult(let result)):
            state.ratesResult = result
        default: break
        }

        return []
    }
    
//    mutating func reduce(event: RatesState.Event) {
//        switch event {
//        case .initial: break
//
//
//            switch result {
//            case .success(let rates),
//                 .today(let rates, _),
//                 .yesterday(let rates, _):
//                viewState.isLoading = false
//                viewState.content = RatesTableSection.makeContent(for: rates)
//            default: break
//            }
//        case .refreshRates:
//            viewState.isLoading = true
//            ratesResult = nil
//
//        case .openEditMode: break;
//            // editModeAction = .open
//            // edit = CurrenciesState()
//        case .editModeOpened: break // editModeAction = nil
//        case .editModeClosed: break // editModeAction = nil
//            // edit = nil
//        case .edit(let editEvent): break //edit?.reduce(event: editEvent)
//        case .cancelEditing,
//             .editingDone: break // editModeAction = .close
//        }
//    }
}

//extension RatesState {
//    var queryAcquireRates: Bool? {
//        return (ratesResult == nil) ? true : nil
//    }
//
//    var queryOpenEditMode: Bool? {
//        return (editModeAction == .open) ? true : nil
//    }
//
//    var queryCloseEditMode: Bool? {
//        return (editModeAction == .close) ? true : nil
//    }
//}
//

private extension RatesState {
    static let fetchRatesEffect = Effect<AppState.Event, AppEnvironment> { env in
        env.fetchRates(Date()).map { .rates(.ratesResult($0)) }
    }
}
