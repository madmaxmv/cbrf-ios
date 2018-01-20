//
//  Copyright © 2017 Tutu.tu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// UINavigationController, который умеет обновлять у координатора currentViewController
/// устанавливая туда контроллер, который отображен в его стеке.
/// Например при переходе по кнопке назад либо свайпе назад.
class NavigationController: UINavigationController, ViewType {

    var state: Driver<Void>!
    private let bag = DisposeBag()

    func subscribe(to appStateStore: AppStateStore) {

        // Output
        rx.didShow
            .asDriver()
            .drive(onNext: { controller, _ in
                (UIApplication.shared.delegate as? AppDelegate)?
                    .coordinator
                    .setCurrentViewController(to: controller)
            })
            .disposed(by: bag)
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
