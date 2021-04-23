//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesRequest {

    let date: Date
}

extension RatesRequest: APIRequest {

    typealias Response = RatesResponse

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

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
