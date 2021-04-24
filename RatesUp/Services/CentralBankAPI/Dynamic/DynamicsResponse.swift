//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct DynamicsResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case dynamics = "Record"
    }
    
    let dynamics: [DynamicsRateAPIRecord]
}
