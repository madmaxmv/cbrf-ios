//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

typealias RateDynamicsResult = Result<RateDynamics, RatesError>

struct RateDynamics: Equatable {

    let dynamics: [CurrencyValue]

    struct CurrencyValue: Equatable {
        let date: Date
        let value: Double
        let originValue: String
    }
}

