//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Tab Bar Controller основного меню.
class TabBarController: UITabBarController, DataDrivenView {

    var state: Driver<TabBarViewState>!

    private let bag = DisposeBag()

    func subscribe(to stateStore: AppStateStore) {

        // Input State
        state = stateStore.stateBus
            .map { $0.tabBarState }
            .distinctUntilChanged()

        // UI
        state
            .map { $0.tabs.map { tab in tab.viewController() } }
            .drive(onNext: { [weak self] (controllers) in
                self?.viewControllers = controllers
            })
            .disposed(by: bag)

        // Output Events
        rx.didSelect
            .asDriver()
            .drive(onNext: {
                (UIApplication.shared.delegate as? AppDelegate)?
                    .coordinator
                    .setCurrentViewController(to: $0)
            })
            .disposed(by: bag)
    }
}
