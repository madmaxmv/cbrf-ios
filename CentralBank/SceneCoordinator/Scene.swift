//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import StoreKit

/// Сцены приложения.
enum Scene {
    /// Таб-бар приложения.
    case tabBar
    /// Сцена для редактирования списка валют.
    case editRates
}

/// MARK: - Scene + viewController(appStateStore:)
extension Scene {

    var viewController: UIViewController {
//        let stateStore = ((UIApplication.shared.delegate as? AppDelegate)?.appStateStore)!
        switch self {
        case .tabBar:
            var tabBarController = TabBarController()
//            tabBarController.bind(with: stateStore)
            return tabBarController
        case .editRates:
            var vc = СurreniesViewController()
            var nc = NavigationController(rootViewController: vc)
//            nc.bind(with: stateStore)
//            vc.bind(with: stateStore)
            return nc
        }
    }
}
