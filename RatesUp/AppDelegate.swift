//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: SceneCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        coordinator = SceneCoordinatorImpl(window: window!)
        let services = Services(groupIdentifier: "group.ru.madmaxmv.ratesup")
        
//        let sideEffects = AppSideEffects(coordinator: coordinator,
//                                         services: services,
//                                         backgroundScheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        
//        appStateStore = AppStateStore(sideEffects: sideEffects)
//        appStateStore.run()
        
        coordinator.transition(to: .tabBar, type: .root)

        return true
    }
}
