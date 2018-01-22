//
//  RatesSideEffects.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxFeedback

protocol RatesSideEffects: SideEffects {
    /// Получение курсов валют.
    var acquireRates: () -> Observable<SideEffects.State.Event> { get }
}

extension RatesSideEffects {
    var effects: [SideEffects.ScheduledEffect] {
        return [
            react(query: { $0.rates.queryAcquireRates }, effects: acquireRates)
        ]
    }
}

struct RatesSideEffectsImpl: RatesSideEffects {
    
    var acquireRates: () -> Observable<SideEffects.State.Event> {
        return {
            let rates: [RateModel] = [
                RateModel(code: 0,
                          characterCode: "USD",
                          currencyName: "Доллар США",
                          nominal: 1, value: 19.00,
                          difference: 0.14)
            ]
            return .just(.rates(.ratesAcquired(rates)))
        }
    }
}

