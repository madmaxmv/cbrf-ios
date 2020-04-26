//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

enum RatesError: Equatable, Error {
    case emptyStore
    case storeUnavailable
    case responseFailed
}
