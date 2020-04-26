//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum Tab {
    case exchangeRates
}

class TabBarController: UITabBarController {
    private let store: AppStore
    private let bag = DisposeBag()

    init(store: AppStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)

        store.state.map { $0.tabs }
            .distinctUntilChanged()
            .map { tabsCreator(store: store, tabs: $0) }
            .bind(onNext: { [weak self] controllers in
                 self?.viewControllers = controllers
            })
            .disposed(by: bag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private func tabsCreator(store: AppStore, tabs: [Tab]) -> [UIViewController] {
    return tabs.map {
        switch $0 {
        case .exchangeRates:
            let vc = RatesViewController(store: store)
            vc.tabBarItem = UITabBarItem(
                title: NSLocalizedString("Rates", comment: "Курсы"),
                image: UIImage(),
                selectedImage: UIImage()
            )
            return UINavigationController(rootViewController: vc)
        }
    }
}
