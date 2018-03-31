//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxFeedback

protocol СurreniesSideEffects {
    /// Получение списка валют.
    var loadCurrenies: () -> Observable<SideEffects.State.Event> { get }
}

extension СurreniesSideEffects {
    var effects: [SideEffects.ScheduledEffect] {
        return [
            react(query: { $0.rates.edit?.queryLoadCurrenies }, effects: loadCurrenies)
        ]
    }
}

struct СurreniesSideEffectsImpl: СurreniesSideEffects {
    
    private let _services: AppServices
    private let _coordinator: SceneCoordinator
    
    init(services: AppServices, coordinator: SceneCoordinator) {
        _services = services
        _coordinator = coordinator
    }
    
    var loadCurrenies: () -> Observable<SideEffects.State.Event> {
        return {
            self._services.ratesService
                .currenies()
                .map { .rates(.edit(.currenies($0))) }
        }
    }
}
