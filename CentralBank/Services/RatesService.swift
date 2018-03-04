 //
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Result
import RxSwift

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
    
    func rates(on date: Date) -> Observable<[RateModel]> {
        let yesterday = _dateConverter.date(removedTimeOffsetFor: date.addingTimeInterval(-24 * 60 * 60))
        let today = _dateConverter.date(removedTimeOffsetFor: date)

        return Observable
            .combineLatest(dailyRates(on: yesterday), dailyRates(on: today)) { yesterdayRates, todayRates in
                
                
                return zip(yesterdayRates, todayRates)
                    .flatMap { yesterdayRate, todayRate in
                        guard yesterdayRate.code == todayRate.code else {
                            return nil
                        }
                        return RateModel(apiModel: todayRate,
                                         difference: todayRate.value - yesterdayRate.value)
                    }
            }.catchError { error in
                return self.dailyRates(on: yesterday)
                    .map { rates in
                        return rates.map { RateModel(apiModel: $0) }
                }
        }
    }
    
    func dailyRates(on date: Date) -> Observable<[CurrencyDailyRate]> {
        return Observable<[CurrencyDailyRate]>
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
