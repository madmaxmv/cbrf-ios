//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import SWXMLHash

struct DailyRatesData {
    let rates: [RateAPIModel]
}

extension DailyRatesData: XMLDecodable {
    init(xml: XMLIndexer) {
        rates = xml["ValCurs"].children.map {
            RateAPIModel(xml: $0)
        }
    }
}
