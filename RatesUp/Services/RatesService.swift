//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Combine
import Foundation

struct RatesService {
    /// Сервис для доступа к удаленным данным.
    private let _remote: RatesUpService
    /// Локальное хранилище данных.
    private let _store: RatesStore?
    /// Конвертер для преобразования даты.
    private let _dateConverter: DateConverter
    
    init(remote: RatesUpService,
         store: RatesStore?,
         dateConverter: DateConverter) {
        _remote = remote
        _store = store
        _dateConverter = dateConverter
    }
    
    func rates(
        on date: Date,
        sortedUsing policy: RatesSort.Policy = .standard
    ) -> AnyPublisher<RatesResult, Error> {

        let yesterday = _dateConverter.date(removedTimeOffsetFor: date.addingTimeInterval(-24 * 60 * 60))
        let today = _dateConverter.date(removedTimeOffsetFor: date)
        let sortMethod = RatesSort.sort(for: policy)

        return Publishers
            .CombineLatest(dailyRates(on: yesterday), dailyRates(on: today))
            .map { yesterdayRates, todayRates in
                let _rates: [CurrencyDailyRate] = zip(yesterdayRates, todayRates)
                    .compactMap { yesterdayRate, todayRate in
                        guard yesterdayRate.code == todayRate.code else {
                            return nil
                        }
                        return CurrencyDailyRate(
                            apiModel: todayRate,
                            difference: todayRate.value - yesterdayRate.value
                        )
                    }
                return RatesResult.success(rates: sortMethod(_rates))
//            }
//            .catch { error in

//                guard let ratesError = error as? RatesError else {
//                    return Fail(error)
//                }
//                return self.dailyRates(on: today)
//                    .map { rates in
//                        return rates.map { CurrencyDailyRate(apiModel: $0) }
//                    }
//                    .map { sortMethod($0) }
//                    .map { RatesResult.today(rates: $0, error: ratesError) }
            }
            .catch { error -> AnyPublisher<RatesResult, Error> in
                print(error)
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func currencies() -> Future<[Currency], Error> {
        return Future { promise in
            self._store?.currencies { currenies in
                promise(.success(currenies))
            }
        }
    }
    
    func dailyRates(on date: Date) -> AnyPublisher<[RateAPIModel], Error> {
        return Future { promise in
            self._store?.getRates(on: date) { rates in
                rates.isEmpty
                    ? promise(.failure(RatesError.emptyStore))
                    : promise(.success(rates))
            } ?? promise(.failure(RatesError.storeUnavailable))
        }.catch { _ in
            self._remote.rates(on: date)
                .map { $0.rates }
//                .do(onNext: { self._store?.save(rates: $0, on: date) } )
        }.eraseToAnyPublisher()
    }
}
