//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import UIKit
import Nivelir

struct RatesScreen: Screen {

    let services: AppServices
    
    func build(navigator: ScreenNavigator, payload: Any?) -> UIViewController {
        RatesViewController(
            store: RatesStateStore(
                initial: .initial,
                reducer: RatesState.reducer,
                environment: RatesEnvironment(
                    services: services
                )
            )
        )
    }
}
