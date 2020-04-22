//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesState {
    var viewState: RatesViewState = .initial

    var ratesResult: RatesResult? = nil
    var editModeAction: SceneAction? = nil
    var edit: CurrenciesState? = nil
}

extension RatesState {
    enum Event {
        case ratesResult(RatesResult)
        case refreshRates
        case openEditMode
        case editModeOpened, editModeClosed
        case edit(CurrenciesState.Event)
        case cancelEditing, editingDone
    }
}

extension RatesState {
    mutating func reduce(event: RatesState.Event) {
        switch event {
        case .ratesResult(let result):
            ratesResult = result
            
//            switch result {
//            case .success(let rates),
//                 .today(let rates, _),
//                 .yesterday(let rates, _):
//                viewState.isLoading = false
//                viewState.content = RatesTableSection.makeContent(for: rates)
//            default: break
//            }
        case .refreshRates:
//            viewState.isLoading = true
            ratesResult = nil
            
        case .openEditMode:
            editModeAction = .open
            edit = CurrenciesState()
        case .editModeOpened: editModeAction = nil
        case .editModeClosed: editModeAction = nil
            edit = nil
        case .edit(let editEvent): edit?.reduce(event: editEvent)
        case .cancelEditing,
             .editingDone: editModeAction = .close
        }
    }
}

extension RatesState {
    var queryAcquireRates: Bool? {
        return (ratesResult == nil) ? true : nil
    }

    var queryOpenEditMode: Bool? {
        return (editModeAction == .open) ? true : nil
    }

    var queryCloseEditMode: Bool? {
        return (editModeAction == .close) ? true : nil
    }
}

