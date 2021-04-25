//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import UIKit
import Nivelir

struct CurrencyRateScreen: Screen {

    let currencyRate: CurrencyDailyRate

    func build(navigator: ScreenNavigator, payload: Any?) -> UIViewController {
        CurrencyRateViewController()
    }
}
