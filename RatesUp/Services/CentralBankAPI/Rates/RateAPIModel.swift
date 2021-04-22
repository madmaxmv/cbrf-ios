//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RateAPIModel: Decodable {

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case code = "NumCode"
        case characterCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
    }

    let id: String
    let code: String
    let characterCode: String
    let nominal: Int
    let name: String
    let value: String
}
