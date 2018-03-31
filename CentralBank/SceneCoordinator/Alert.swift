//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

enum Alert {
    struct Data {
        let title: String
        let message: String?
        let actions: [Action]
    }

    struct Action {
        let title: String
        let style: UIAlertActionStyle
        let handler: ((UIAlertAction) -> Void)?
    }

    case alert(data: Data)
    case actionSheet(data: Data, sender: UIView)
}

extension Alert {

    init(title: String, message: String) {
        let okString = NSLocalizedString("OK", comment: "OK")
        let okAction = Alert.Action(title: okString, style: .default, handler: nil)

        let data = Alert.Data(title: title, message: message, actions: [okAction])
        self = .alert(data: data)
    }
}
