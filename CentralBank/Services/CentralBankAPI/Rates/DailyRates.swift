//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import SWXMLHash

struct DailyRates {
    let rates: [CurrencyDailyRate]
}

extension DailyRates: XMLDecodable {
    init(xml: XMLIndexer) {
        rates = xml["ValCurs"].children.map {
            CurrencyDailyRate(xml: $0)
        }
    }
}
