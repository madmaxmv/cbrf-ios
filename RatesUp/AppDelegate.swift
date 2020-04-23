//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

typealias AppStore = Store<AppState, AppState.Event, AppEnvironment>

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let services = Services(groupIdentifier: "group.ru.madmaxmv.ratesup")

        let stateStore = AppStore(
            initial: AppState.initial,
            reducer: AppState.reducer,
            environment: AppEnvironment()
        )

//        let sideEffects = AppSideEffects(coordinator: coordinator,
//                                         services: services,
//                                         backgroundScheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        
//        appStateStore = AppStateStore(sideEffects: sideEffects)
//        appStateStore.run()

        window?.rootViewController = TabBarController(
            store: stateStore
        )

        return true
    }
}
