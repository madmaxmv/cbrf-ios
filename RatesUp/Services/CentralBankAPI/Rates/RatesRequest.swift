//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesRequest {

    let date: Date
}

extension RatesRequest {

    func toAPIRequest(using dateFormatter: DateFormatter) -> APIRequest<RatesResponse> {
        APIRequest(
            endpoint: "/XML_daily_eng.asp",
            method: .get {
                URLQueryItem(
                    name: "date_req",
                    value: dateFormatter.string(from: date)
                )
            }
        )
    }
}
