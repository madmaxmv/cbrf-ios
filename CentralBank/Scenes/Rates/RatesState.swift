//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

final class RatesState: State {
    /// ViewState экрана с курсом валют.
    var viewState: RatesViewState = .initial

    /// Все курсы валют.
    var ratesResult: RatesResult? = nil
    /// Событие открытия/закрытия сцены с редактированием списка валют.
    var editModeAction: SceneAction? = nil
    /// Стейт экрана изменения списка валют.
    var edit: СurreniesState? = nil
}

extension RatesState {
    enum Event {
        case ratesResult(RatesResult)
        case refreshRates
        case openEditMode
        case editModeOpened
        case edit(СurreniesState.Event)
    }
}

extension RatesState {
    func reduce(event: RatesState.Event) {
        switch event {
        case .ratesResult(let result):
            ratesResult = result
            
            switch result {
            case .success(let rates),
                 .today(let rates, _),
                 .yesterday(let rates, _):
                viewState.isLoading = false
                viewState.content = RatesTableSection.makeContent(for: rates)
            default: break
            }
        case .refreshRates:
            viewState.isLoading = true
            ratesResult = nil
        case .openEditMode: editModeAction = .open
        case .editModeOpened: editModeAction = nil
        case .edit(let editEvent): edit?.reduce(event: editEvent)
        }
    }
}

extension RatesState {
    var queryAcquireRates: Void? {
        return (ratesResult == nil) ? () : nil
    }

    var queryOpenEditMode: Void? {
        return (editModeAction == .open) ? () : nil
    }

    var queryCloseEditMode: Void? {
        return (editModeAction == .close) ? () : nil
    }
}

