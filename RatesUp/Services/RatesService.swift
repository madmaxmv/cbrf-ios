//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Combine

// MARK: - RatesProvider
protocol RatesProvider {

    func rates(
        on date: Date,
        sortingPolicy: RatesSort.Policy
    ) -> AnyPublisher<ExchangeRates, Error>
}

extension RatesProvider {
    
    func rates(on date: Date) -> AnyPublisher<ExchangeRates, Error> {
        rates(on: date, sortingPolicy: .standard)
    }
}

// MARK: - RatesService
final class RatesService {
    private let remote: RatesAPI
    private let store: RatesStore?
    private let dateConverter: DateConverter

    init(
        remote: RatesAPI,
        store: RatesStore?,
        dateConverter: DateConverter
    ) {
        self.remote = remote
        self.store = store
        self.dateConverter = dateConverter
    }

    private func fetchRates(on date: Date) -> AnyPublisher<[CurrencyRate], Error> {
        return Future { promise in
            self.store?.getRates(on: date) { rates in
                rates.isEmpty
                    ? promise(.failure(RatesError.emptyStore))
                    : promise(.success(rates))
            } ?? promise(.failure(RatesError.storeUnavailable))
        }
        .catch { error -> AnyPublisher<[CurrencyRate], Error> in
            self.remote
                .send(request: RatesRequest(date: date))
                .map { response in
                    response.rates.compactMap {
                        CurrencyRate(rate: $0)
                    }
                }
                .mapError { $0 as Error }
                .handleEvents(receiveOutput: {
                    self.store?.save(rates: $0, on: date)
                })
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

extension RatesService: RatesProvider {

    func rates(
        on date: Date,
        sortingPolicy: RatesSort.Policy = .standard
    ) -> AnyPublisher<ExchangeRates, Error> {
        let sortMethod = RatesSort.sort(using: sortingPolicy)

        return fetchRates(on: date)
            .map { ExchangeRates(rates: sortMethod($0)) }
            .eraseToAnyPublisher()
    }
}

// MARK: -
extension CurrencyRate {

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
