//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

enum Assets {
    enum ImageName: String {
        case exchangeRatesSelectedTab   = "Exchange-rates-selected-tab"
        case exchangeRatesDeselectedTab = "Exchange-rates-deselected-tab"
    }

    static func image(named name: ImageName) -> UIImage {
        guard let image = UIImage(named: name.rawValue) else {
            assertionFailure("Assets does't contains image with name '\(name.rawValue)'")
            return UIImage()
        }
        return image
    }
}
