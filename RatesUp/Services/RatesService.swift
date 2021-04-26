//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Combine

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
    
    func rates(
        on date: Date,
        sortedUsing policy: RatesSort.Policy = .standard
    ) -> AnyPublisher<DailyRates, Error> {
        let today = dateConverter.date(removedTimeOffsetFor: date)
        let sortMethod = RatesSort.sort(for: policy)

        return dailyRates(on: today)
            .map { DailyRates(rates: sortMethod($0)) }
            .eraseToAnyPublisher()
    }

    func currencies() -> Future<[Currency], Error> {
        return Future { promise in
            self.store?.currencies { currencies in
                promise(.success(currencies))
            }
        }
    }

    func dailyRates(on date: Date) -> AnyPublisher<[CurrencyRate], Error> {
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
