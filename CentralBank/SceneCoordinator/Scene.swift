//
//  Copyright © 2017 Tutu.tu. All rights reserved.
//

import UIKit
import StoreKit

/// Сцены приложения.
enum Scene {
    /// Таб-бар приложения.
    case tabBar
}

/// MARK: - Scene + viewController(appStateStore:)
extension Scene {

    var viewController: UIViewController {
        let appStateStore = ((UIApplication.shared.delegate as? AppDelegate)?.appStateStore)!
        switch self {
        case .tabBar:
            var tabBarController = TabBarController()
            tabBarController.bind(with: appStateStore)
            return tabBarController
        }
    }
}
