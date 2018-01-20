//
//  AppDelegate.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appStateStore: AppStateStore!
    var coordinator: SceneCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        coordinator = SceneCoordinatorImpl(window: window!)
        let sideEffects = AppSideEffects(coordinator: coordinator,
                                         backgroundScheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        
        appStateStore = AppStateStore(sideEffects: sideEffects)
        appStateStore.run()
        
        coordinator.transition(to: .tabBar, type: .root)

        return true
    }
}
