//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

enum APIError: Error {
    case networking(URLError)
    case decoding(Swift.Error)
}
