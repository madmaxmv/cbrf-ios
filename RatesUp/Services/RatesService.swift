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
    ) -> AnyPublisher<RatesResult, Error> {
        let today = dateConverter.date(removedTimeOffsetFor: date)
        let sortMethod = RatesSort.sort(for: policy)

        return dailyRates(on: today)
            .map { RatesResult.success(rates: sortMethod($0)) }
            .eraseToAnyPublisher()
    }

    func currencies() -> Future<[Currency], Error> {
        return Future { promise in
            self.store?.currencies { currencies in
                promise(.success(currencies))
            }
        }
    }

    func dailyRates(on date: Date) -> AnyPublisher<[CurrencyDailyRate], Error> {
        return Future { promise in
            self.store?.getRates(on: date) { rates in
                rates.isEmpty
                    ? promise(.failure(RatesError.emptyStore))
                    : promise(.success(rates))
            } ?? promise(.failure(RatesError.storeUnavailable))
        }
        .catch { error -> AnyPublisher<[CurrencyDailyRate], Error> in
            self.remote.rates(on: date)
                .mapError { $0 as Error }
                .handleEvents(receiveOutput: {
                    self.store?.save(rates: $0, on: date)
                })
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}
