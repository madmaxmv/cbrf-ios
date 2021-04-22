//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    var endpoint: String { get }
    var method: APIMethod { get }
}
