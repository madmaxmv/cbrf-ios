//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

typealias AppStore = Store<AppState, AppState.Event, AppEnvironment>

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var store: AppStore?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let services = Services(
            groupIdentifier: "group.ru.madmaxmv.ratesup"
        )

        let stateStore = AppStore(
            initial: AppState.initial,
            reducer: AppState.reducer,
            environment: AppEnvironment(services: services)
        )

        window?.rootViewController = TabBarController(
            store: stateStore
        )

        stateStore.send(.rates(.initial))
        store = stateStore

        return true
    }
}
