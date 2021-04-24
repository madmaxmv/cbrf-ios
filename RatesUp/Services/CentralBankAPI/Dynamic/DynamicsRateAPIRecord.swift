//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct DynamicsRateAPIRecord: Decodable {

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case value = "Value"
    }

    let date: String
    let value: String
}
