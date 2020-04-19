//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

/// Пункты меню приложения.
enum TabItem {
    /// Курс валют.
    case exchangeRates(index: Int, title: String, icon: UIImage, selectedIcon: UIImage)

    var index: Int {
        switch self {
        case let .exchangeRates(index, _, _, _):
            return index
        }
    }
}

extension TabItem {

    func viewController() -> UIViewController {
        let appStateStore = ((UIApplication.shared.delegate as? AppDelegate)?.appStateStore)!

        switch self {
        case let .exchangeRates(_, title, icon, selectedIcon):
            var vc = RatesViewController(nibName: "Rates", bundle: nil)
            vc.tabBarItem = UITabBarItem(title: title, image: icon, selectedImage: selectedIcon)
            var nc = NavigationController(rootViewController: vc)

            // enable slide-back action when navigation bar hidden.
            nc.interactivePopGestureRecognizer?.isEnabled = true
            nc.interactivePopGestureRecognizer?.delegate = nc

            nc.bind(with: appStateStore)
            vc.bind(with: appStateStore)
            return nc
        }
    }
}
