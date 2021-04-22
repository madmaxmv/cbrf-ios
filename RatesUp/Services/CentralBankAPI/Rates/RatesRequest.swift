//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesRequest: APIRequest {
    typealias Response = RatesResponse

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    let date: Date

    var endpoint: String { "/XML_daily.asp" }
    var method: APIMethod {
        .get {
            URLQueryItem(
                name: "date_req",
                value: RatesRequest.dateFormatter
                    .string(from: date)
            )
        }
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
