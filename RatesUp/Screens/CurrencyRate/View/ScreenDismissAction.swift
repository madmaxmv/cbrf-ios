//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import UIKit
import Nivelir

struct ScreenDismissAction<Container: UIViewController>: ScreenAction {

    typealias Output = Void
    typealias Completion = (Result<Output, Error>) -> Void

    public let animated: Bool

    public init(animated: Bool = true) {
        self.animated = animated
    }

    public func perform(
        container: Container,
        navigation: ScreenNavigation,
        completion: @escaping Completion
    ) {
        navigation.logger?.info("Dismissing screen presented by \(container)")

        container.dismiss(animated: animated) {
            completion(.success)
        }
    }
}

extension ScreenRoute where Container: UIViewController {

    public func dismissScreen(animated: Bool = true) -> Self {
        then(action: ScreenDismissAction<Container>(animated: animated))
    }
}

fileprivate extension Result where Success == Void, Failure == Error {
    static var success: Self { .success(()) }
}
