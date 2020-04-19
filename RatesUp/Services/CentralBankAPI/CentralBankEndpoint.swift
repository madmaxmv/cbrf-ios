//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Moya

enum RatesUpEndpoint {
    case rates(Date)
}

extension RatesUpEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: "http://www.cbr.ru/scripts/")!
    }
    
    var path: String {
        switch self {
        case .rates:
            return "XML_daily.asp"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .rates(let date):
            let dateParameter = RatesUpEndpoint.dateFormatter.string(from: date)
            return "{\"date_req\": \(dateParameter)}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .rates(let date):
            return .requestParameters(parameters: ["date_req": RatesUpEndpoint.dateFormatter.string(from: date)],
                                      encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
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
