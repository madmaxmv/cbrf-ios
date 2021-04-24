//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct DynamicsRequest {

    let currencyID: String
    let range: (from: Date, to: Date)
}

extension DynamicsRequest {

    func toAPIRequest(using dateFormatter: DateFormatter) -> APIRequest<DynamicsResponse> {
        APIRequest(
            endpoint: "/XML_dynamic.asp",
            method: .get {
                URLQueryItem(
                    name: "VAL_NM_RQ",
                    value: currencyID
                )
                URLQueryItem(
                    name: "date_req1",
                    value: dateFormatter.string(from: range.from)
                )
                URLQueryItem(
                    name: "date_req2",
                    value: dateFormatter.string(from: range.to)
                )
            }
        )
    }
}
