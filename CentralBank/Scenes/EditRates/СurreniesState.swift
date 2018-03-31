//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

final class СurreniesState: State {
    /// ViewState экрана с курсом валют.
    var viewState: СurreniesViewState = .initial

    /// Признак того, что необходимо загрузить список валют.
    var shouldLoadCurrenies = true
    /// Список валют.
    var currenies: [Currency] = []

}

extension СurreniesState {
    enum Event {
        case currenies([Currency])
    }
}

extension СurreniesState {
    func reduce(event: Event) {
        switch event {
        case .currenies(let currenies):
            shouldLoadCurrenies = false
            self.currenies = currenies
        }
    }
}

extension СurreniesState {
    var queryLoadCurrenies: Void? {
        return shouldLoadCurrenies ? () : nil
    }
}
