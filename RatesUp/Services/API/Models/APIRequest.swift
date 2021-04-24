//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct APIRequest<Response> {
    let endpoint: String
    let method: APIMethod
}
