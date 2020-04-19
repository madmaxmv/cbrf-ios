//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Result
import RxSwift

struct RatesService {
    /// Сервис для доступа к удаленным даным.
    private let _remote: CentralBankService
    /// Локальное хранилище данных.
    private let _store: RatesStore?
    /// Конвертер для преобразования даты.
    private let _dateConverter: DateConverter
    
    init(remote: CentralBankService,
         store: RatesStore?,
         dateConverter: DateConverter) {
        _remote = remote
        _store = store
        _dateConverter = dateConverter
    }
    
    func rates(on date: Date,
               sortedUsing policy: RatesSort.Policy = .standard) -> Observable<RatesResult> {

        let yesterday = _dateConverter.date(removedTimeOffsetFor: date.addingTimeInterval(-24 * 60 * 60))
        let today = _dateConverter.date(removedTimeOffsetFor: date)
        let sortMethod = RatesSort.sort(for: policy)

        return Observable
            .combineLatest(dailyRates(on: yesterday), dailyRates(on: today)) { yesterdayRates, todayRates in
                let _rates: [CurrencyDailyRate] = zip(yesterdayRates, todayRates)
                    .compactMap { yesterdayRate, todayRate in
                        guard yesterdayRate.code == todayRate.code else {
                            return nil
                        }
                        return CurrencyDailyRate(apiModel: todayRate,
                                                 difference: todayRate.value - yesterdayRate.value)
                    }
                return RatesResult.success(rates: sortMethod(_rates))
            }.catchError { error in
                guard let ratesError = error as? RatesError else {
                    return .error(error)
                }
                return self.dailyRates(on: today)
                    .map { rates in
                        return rates.map { CurrencyDailyRate(apiModel: $0)}
                    }
                    .map { sortMethod($0) }
                    .map { RatesResult.today(rates: $0, error: ratesError) }
        }
    }

    func currencies() -> Observable<[Currency]> {
        return Observable<[Currency]>
            .create { observer in
                self._store?.currencies { currenies in
                    observer.on(.next(currenies))
                    observer.on(.completed)
                }
                return Disposables.create()
        }
    }
    
    func dailyRates(on date: Date) -> Observable<[RateAPIModel]> {
        return Observable<[RateAPIModel]>
            .create { observer in
                self._store?.getRates(on: date) { rates in
                    rates.isEmpty
                        ? observer.on(.error(RatesError.emptyStore))
                        : observer.on(.next(rates))
                    } ?? observer.on(.error(RatesError.storeUnavailable))
                
                return Disposables.create()
            }.catchError { _ in
                return self._remote
                    .rates(on: date)
                    .map { $0.rates }
                    .do(onNext: { self._store?.save(rates: $0, on: date) } )
        }
    }
}
