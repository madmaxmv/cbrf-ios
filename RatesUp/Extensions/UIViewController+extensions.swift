//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import UIKit
import SwiftUI

extension UIViewController {

    func setHostingController<Content>(_ controller: UIHostingController<Content>) {
        addChild(controller)
        view.addSubview(controller.view, constraints: [
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        controller.didMove(toParent: self)
    }
}
