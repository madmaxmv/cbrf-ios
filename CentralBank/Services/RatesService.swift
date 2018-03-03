 //
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Result
import RxSwift

enum RatesError: Error {
    case emptyStore
    case storeUnavailable
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
    
    func rates(on date: Date) -> Observable<[CurrencyDailyRate]> {
        let searchDate = _dateConverter.date(removedTimeOffsetFor: date)

        return Observable<[CurrencyDailyRate]>
            .create { observer in
                self._store?.getRates(on: searchDate) { rates in
                    rates.isEmpty
                        ? observer.on(.error(RatesError.emptyStore))
                        : observer.on(.next(rates))
                } ?? observer.on(.error(RatesError.storeUnavailable))

                return Disposables.create()
            }.catchError { _ in
                return self._remote
                    .rates(on: searchDate)
                    .map { $0.rates }
                    .do(onNext: { self._store?.save(rates: $0, on: searchDate) } )
            }
    }
}
