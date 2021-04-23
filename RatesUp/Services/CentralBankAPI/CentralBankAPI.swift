//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Combine
import Foundation
import XMLParsing

protocol RatesAPI {

    func rates(on date: Date) -> AnyPublisher<[CurrencyDailyRate], APIError>
}


final class CentralBankAPI {

    private static let configuration = APIConfiguration(
        baseURL: { URL(string: "http://www.cbr.ru/scripts")! }
    )

    private let apiProvider: APIProvider

    init(apiProvider: APIProvider) {
        self.apiProvider = apiProvider
    }

    convenience init(session: URLSession) {
        self.init(
            apiProvider: APIProviderImpl(
                session: session,
                configuration: CentralBankAPI.configuration
            )
        )
    }
}

extension CentralBankAPI: RatesAPI {

    func rates(on date: Date) -> AnyPublisher<[CurrencyDailyRate], APIError> {
        apiProvider.publisher(
            for: RatesRequest(date: date),
            using: XMLDecoder()
        )
        .map { response in
            response.rates
                .compactMap { CurrencyDailyRate(rate: $0) }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - XMLDecoder + TopLevelDecoder
extension XMLDecoder: TopLevelDecoder {
    public typealias Input = Data
}

// MARK: -
extension CurrencyDailyRate {

    init?(rate: RateAPIModel) {
        guard
            let value = Double(rate.value.replacingOccurrences(of: ",", with: "."))
        else {
            return nil
        }

        self.init(
            id: rate.id,
            code: rate.code,
            characterCode: rate.characterCode,
            currencyName: rate.name,
            nominal: rate.nominal,
            value: value
        )
    }
}
