//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Tab Bar Controller основного меню.
class TabBarController: UITabBarController {

    var state = PublishSubject<TabBarViewState>()

    private let bag = DisposeBag()

    func newState(state: TabBarViewState) {
        self.state.on(.next(state))
    
        // UI
        self.state
            .map { $0.tabs.map { tab in tab.viewController() } }
            .bind(onNext: { [weak self] (controllers) in
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
