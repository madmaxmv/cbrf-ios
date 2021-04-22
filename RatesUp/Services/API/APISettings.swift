//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct APISettings {

    let baseURL: () -> String
}

extension APISettings {

    static let cbr = APISettings(
        baseURL: { "http://www.cbr.ru/scripts" }
    )
}
