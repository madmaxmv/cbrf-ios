//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import SwiftUI
import Combine

enum Tab {
    case exchangeRates
}

class TabBarController: UITabBarController {

    private var subscriptions: Set<AnyCancellable> = []

    init(store: AppStore) {
        super.init(nibName: nil, bundle: nil)

        store.state.map(\.tabs)
            .removeDuplicates()
            .sink { [weak self] tabs in
                self?.updateTabs(tabs, store: store)
            }
            .store(in: &subscriptions)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTabs(_ tabs: [Tab], store: AppStore) {
        viewControllers = tabs.map { tab in
            TabBarController.createViewController(
                for: tab, store: store
            )
        }
    }
}
private extension TabBarController {

    private static func createViewController(
        for tab: Tab, store: AppStore
    ) -> UIViewController {
            switch tab {
            case .exchangeRates:
                let vc = RatesViewController(
                    store: store
                )
                vc.tabBarItem = UITabBarItem(
                    title: NSLocalizedString("Rates", comment: "Курсы"),
                    image: UIImage(),
                    selectedImage: UIImage()
                )
                return vc
            }
    }
}
