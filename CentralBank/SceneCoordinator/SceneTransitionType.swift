//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

enum SceneTransitionType {
    // you can extend this to add animated transition types,
    // interactive transitions and even child view controllers!

    /// Make view controller the root view controller.
    case root
    /// Push view controller to navigation stack.
    case push(animated: Bool)
    /// Present view controller modally.
    case modal(animated: Bool)
}
