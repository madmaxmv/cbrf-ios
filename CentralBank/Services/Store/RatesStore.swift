//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

protocol RatesStore {
    
    func save(rates: [CurrencyDailyRate], on date: Date)
    
    func getRates(on date: Date, completion: @escaping (([CurrencyDailyRate]) -> Void))
}

extension LocalStore: RatesStore {
    
    func save(rates: [CurrencyDailyRate], on date: Date) {
        writeContext.performChanges { context in
            rates.forEach { currencyRate in
                let currency = Currency.findOrCreate(in: context,
                                                     matching: Currency.predicate(byId: currencyRate.id))
                { currency in
                    currency.isIncluded = true
                    currency.order = 0
                    currency.currencyId = currencyRate.id
                    currency.currencyCode = currencyRate.code
                    currency.characterCode = currencyRate.characterCode
                    currency.name = currencyRate.name
                    currency.nominal = Int64(currencyRate.nominal)
                }
                
                let rate = Rate.findOrCreate(in: context,
                                             matching: Rate.predicate(currency: currency, on: date))
                { rate in
                    rate.currency = currency
                }
                rate.date = date
                rate.value = currencyRate.value
            }
        }
    }
    
    func getRates(on date: Date, completion: @escaping (([CurrencyDailyRate]) -> Void)) {
        readContext.perform { context in
            let allCurrenies = Currency.fetch(in: context)
                .filter { $0.isIncluded }

            let rates: [CurrencyDailyRate] = allCurrenies.flatMap { currency in
                guard let rate = Rate.findOrFetch(in: context, matching: Rate.predicate(currency: currency,
                                                                                        on: date))
                    else {
                        return nil
                }
                return CurrencyDailyRate(id: currency.currencyId,
                                         code: currency.currencyCode,
                                         characterCode: currency.characterCode,
                                         nominal: Int(currency.nominal),
                                         name: currency.name,
                                         value: rate.value)
            }
            completion(rates)
        }
    }
}
