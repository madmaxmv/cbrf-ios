//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import Nivelir

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var screensFactory: AppScreens?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let services = Services(
            groupIdentifier: "group.ru.madmaxmv.ratesup",
            screenNavigator: DefaultScreenNavigator(
                windowProvider: ScreenKeyWindowProvider(
                    application: application
                )
            )
        )

        let screensFactory = ScreenFactory(
            services: services
        )

        window?.makeKeyAndVisible()

        services.screenNavigator
            .perform(
                action: ScreenSetRootAction(
                    screen: screensFactory.ratesScreen()
                ),
                completion: nil
            )

        return true
    }
}
