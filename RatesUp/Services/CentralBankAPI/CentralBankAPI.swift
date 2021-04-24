//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Combine
import Foundation
import XMLParsing

protocol RatesAPI {

    func send(request: RatesRequest) -> AnyPublisher<RatesResponse, APIError>
}

protocol DynamicsAPI {

    func send(request: DynamicsRequest) -> AnyPublisher<DynamicsResponse, APIError>
}

final class CentralBankAPI {

    private static let configuration = APIConfiguration(
        baseURL: { URL(string: "http://www.cbr.ru/scripts")! }
    )

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    private let apiProvider: APIProvider
    private let dateFormatter: DateFormatter

    init(
        apiProvider: APIProvider,
        dateFormatter: DateFormatter
    ) {
        self.apiProvider = apiProvider
        self.dateFormatter = dateFormatter
    }

    convenience init(session: URLSession) {
        self.init(
            apiProvider: APIProviderImpl(
                session: session,
                configuration: CentralBankAPI.configuration
            ),
            dateFormatter: CentralBankAPI.dateFormatter
        )
    }
}

extension CentralBankAPI: RatesAPI {

    func send(request: RatesRequest) -> AnyPublisher<RatesResponse, APIError> {
        apiProvider.publisher(
            for: request.toAPIRequest(
                using: dateFormatter
            ),
            using: XMLDecoder()
        )
    }
}

extension CentralBankAPI: DynamicsAPI {

    func send(request: DynamicsRequest) -> AnyPublisher<DynamicsResponse, APIError> {
        apiProvider.publisher(
            for: request.toAPIRequest(
                using: dateFormatter
            ),
            using: XMLDecoder()
        )
    }
}

// MARK: - XMLDecoder + TopLevelDecoder
extension XMLDecoder: TopLevelDecoder {
    public typealias Input = Data
}
