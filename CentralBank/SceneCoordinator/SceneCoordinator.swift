//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SceneCoordinator {
    init(window: UIWindow)

    /// Set current view controller from a tab bar controller.
    func setCurrentViewController(to viewController: UIViewController)

    /// Command to select a specific tab in the current tab bar controller.
    @discardableResult
    func selectSceneTab(_ tabIndex: Int) -> Observable<Void>

    /// Transition to another scene.
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void>

    /// Pop scene from navigation stack or dismiss current modal.
    @discardableResult
    func pop(animated: Bool) -> Observable<Void>

    @discardableResult
    func pop(animated: Bool, skip: Int) -> Observable<Void>

    /// Show an alert or actionSheet.
    @discardableResult
    func show(alert: AlertActionSheet, animated: Bool) -> Observable<String?>
}

extension SceneCoordinator {
    @discardableResult
    func pop() -> Observable<Void> {
        return pop(animated: true)
    }
}

class SceneCoordinatorImpl: SceneCoordinator {

    private var window: UIWindow
    private var currentViewController: UIViewController

    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }

    func setCurrentViewController(to viewController: UIViewController) {
        currentViewController = viewController
    }

    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        let vc: UIViewController
        if let tabBarController = viewController as? UITabBarController {
            vc = tabBarController.viewControllers![tabBarController.selectedIndex]
        } else {
            vc = viewController
        }
        if let navigationController = vc as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return vc
        }
    }

    @discardableResult
    func selectSceneTab(_ tabIndex: Int) -> Observable<Void> {
        return Single.create { [unowned self] single in
            guard let tabBarController = self.currentViewController.tabBarController else {
                fatalError("Can't select a tab without a current tab bar controller")
            }
            guard let items = tabBarController.tabBar.items else {
                fatalError("There are no tab items in a current tab bar controller")
            }
            guard tabIndex >= 0 && tabIndex < items.count else {
                fatalError("There are no tab items in a current tab bar controller")
            }
            tabBarController.selectedIndex = tabIndex
            self.currentViewController = tabBarController.selectedViewController!
            single(.success(()))
            return Disposables.create()
        }.asObservable()
    }

    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        switch type {
        case .root:
            let viewController = scene.viewController
            currentViewController = SceneCoordinatorImpl.actualViewController(for: viewController)
            window.rootViewController = viewController
            subject.onNext(())
        case .push(let animated):

            guard let navigationController = (currentViewController as? UINavigationController)
                ?? currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            let viewController = scene.viewController
            // one-off subscription to be notified when push complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: animated)
            currentViewController = SceneCoordinatorImpl.actualViewController(for: viewController)

        case .modal(let animated):
            let viewController = scene.viewController
            currentViewController.present(viewController, animated: animated) {
                subject.onNext(())
            }
            currentViewController = SceneCoordinatorImpl.actualViewController(for: viewController)
        }
        return subject
    }

    @discardableResult
    func pop(animated: Bool) -> Observable<Void> {

        if let presenter = currentViewController.presentingViewController {
            let subject = PublishSubject<Void>()
            // dismiss a modal controller
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinatorImpl.actualViewController(for: presenter)
                subject.on(.next(()))
            }
            return subject
        } else if currentViewController.navigationController != nil {
            return pop(animated: animated, skip: 1)
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
    }

    @discardableResult
    func pop(animated: Bool, skip: Int) -> Observable<Void> {
        guard let navigationController = currentViewController.navigationController else {
            fatalError()
        }
        let subject = PublishSubject<Void>()
        // navigate up the stack
        // one-off subscription to be notified when pop complete
        _ = navigationController.rx.delegate
            .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in }
            .take(1)
            .bind(to: subject)

        let targetVCIndex = (navigationController.viewControllers.count - 1) - skip
        let targetVC = navigationController.viewControllers[targetVCIndex]
        guard navigationController.popToViewController(targetVC, animated: animated) != nil else {
            fatalError("can't navigate back from \(currentViewController)")
        }
        currentViewController =
            SceneCoordinatorImpl.actualViewController(for: navigationController.viewControllers.last!)
        return subject
    }

    /// Show an alert or actionSheet.
    @discardableResult
    func show(alert: AlertActionSheet, animated: Bool) -> Observable<String?> {
        switch alert {
        case let .alert(data: data, textField: textField):
            return Single
                .create { [unowned self]  single in
                    let alertController = UIAlertController(title: data.title,
                                                            message: data.message,
                                                            preferredStyle: .alert)
                    if textField != nil {
                        alertController.addTextField(configurationHandler: textField)
                    }
                    data.actions
                        .map { action in
                            return UIAlertAction(title: action.title, style: action.style) {
                                action.handler?($0)
                                single(.success(alertController.textFields?.first?.text))
                            }
                        }.forEach {
                            alertController.addAction($0)
                    }
                    self.currentViewController.present(alertController, animated: animated) {
                        // Если надо сюда тоже возможно передать коллбек.
                    }
                    return Disposables.create()
                }
                .asObservable()
        case let .actionSheet(data: data, sender: sender):
            return Single
                .create { [unowned self] single in

                    let actionSheet = UIAlertController(title: data.title,
                                                        message: data.message,
                                                        preferredStyle: .actionSheet)
                    data.actions
                        .map { action in
                            return UIAlertAction(title: action.title, style: action.style) {
                                action.handler?($0)
                                single(.success(nil))
                            }
                        }
                        .forEach {
                            actionSheet.addAction($0)
                    }
                    actionSheet.popoverPresentationController?.sourceView = sender
                    actionSheet.popoverPresentationController?.sourceRect = sender.bounds
                    self.currentViewController.present(actionSheet, animated: animated) {
                        // Если надо сюда тоже возможно передать коллбек.
                    }
                    return Disposables.create()
                }
                .asObservable()
        }
    }
}
