//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import UIKit

extension UIView {

    func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(constraints)
    }
}
