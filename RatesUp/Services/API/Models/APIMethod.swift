//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

enum APIMethod {
    case get([URLQueryItem])
    case put(Data?)
    case post(Data?)
    case delete
}

extension APIMethod {

    var name: String {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        case .delete: return "DELETE"
        }
    }
}

extension APIMethod {

    @resultBuilder struct QueryItemBuilder {
        static func buildBlock(_ queryItems: URLQueryItem?...) -> [URLQueryItem] {
            queryItems.compactMap { $0 }
        }
    }

    static func get(@QueryItemBuilder _ queryItems: () -> [URLQueryItem]) -> APIMethod {
        .get(queryItems())
    }
}


