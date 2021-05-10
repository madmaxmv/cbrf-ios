//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

extension UIColor {

    /// Цвет основных надписей и тайтлов.
    static var mainText: UIColor {
        return UIColor(red: 24/255, green: 66/255, blue: 156/255, alpha: 1.0)
    }

    /// Цвет текста.
    static var text: UIColor {
        return .black
    }

    /// Второстепенный текст.
    static var secondaryText: UIColor {
        return UIColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1.0)
    }

    /// Цвет разделителей.
    static var separator: UIColor {
        return UIColor(red: 224/255, green: 218/255, blue: 207/255, alpha: 1.0)
    }

    /// Цвет спинеров приложения.
    static var activity: UIColor {
        return UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1.0)
    }

    /// Красный цвет в приложении.
    static var red: UIColor {
        return UIColor(red: 152/255, green: 1/255, blue: 8/255, alpha: 1.0)
    }

    /// Зеленый цвет в приложении.
    static var green: UIColor {
        return UIColor(red: 1/255, green: 152/255, blue: 8/255, alpha: 1.0)
    }

    /// Цвет фона приложения.
    static var background: UIColor {
        return UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
    }
}
