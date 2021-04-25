//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

protocol AppScreens {

    var services: AppServices { get }
}

final class ScreenFactory: AppScreens {

    let services: AppServices

    init(services: AppServices) {
        self.services = services
    }
}

extension ScreenFactory {

    func ratesScreen() -> RatesScreen {
        RatesScreen(services: services)
    }
}
