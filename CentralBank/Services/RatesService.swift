 //
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Result
import RxSwift

 enum RatesResult {
    case success(rates: [CurrencyDailyRate])
    case today(rates: [CurrencyDailyRate], error: RatesError)
    case yesterday(rates: [CurrencyDailyRate], error: RatesError)
    case failed(error: RatesError)
 }
 
enum RatesError: Error {
    case emptyStore
    case storeUnavailable
    case responseFailed
}

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
    
    func rates(on date: Date) -> Observable<RatesResult> {
        let yesterday = _dateConverter.date(removedTimeOffsetFor: date.addingTimeInterval(-24 * 60 * 60))
        let today = _dateConverter.date(removedTimeOffsetFor: date)

        return Observable
            .combineLatest(dailyRates(on: yesterday), dailyRates(on: today)) { yesterdayRates, todayRates in
                let _rates: [CurrencyDailyRate] = zip(yesterdayRates, todayRates)
                    .flatMap { yesterdayRate, todayRate in
                        guard yesterdayRate.code == todayRate.code else {
                            return nil
                        }
                        return CurrencyDailyRate(apiModel: todayRate,
                                                 difference: todayRate.value - yesterdayRate.value)
                    }
                return RatesResult.success(rates: _rates)
            }.catchError { error in
                guard let ratesError = error as? RatesError else {
                    return .error(error)
                }
                return self.dailyRates(on: today)
                    .map { rates in
                        return rates.map { CurrencyDailyRate(apiModel: $0)}
                    }
                    .map {
                        return RatesResult.today(rates: $0, error: ratesError)
                }
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
