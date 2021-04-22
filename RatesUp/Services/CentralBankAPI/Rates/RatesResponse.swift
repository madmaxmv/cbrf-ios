//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case rates = "Valute"
    }

    let rates: [RateAPIModel]
}
