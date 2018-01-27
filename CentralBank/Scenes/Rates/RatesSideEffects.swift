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
    
    private let _backgroundScheduler: SchedulerType
    private let _centralBankService: CentralBankService
    
    init(centralBankService: CentralBankService,
         backgroundScheduler: SchedulerType) {
        _backgroundScheduler = backgroundScheduler
        _centralBankService = centralBankService
    }
    
    var acquireRates: () -> Observable<SideEffects.State.Event> {
        return {
            return self._centralBankService
                .rates(on: Date())
                .asObservable()
                .map { apiModels -> [RateModel] in
                    return apiModels.map { RateModel(apiModel: $0) }
                }
                .map { .rates(.ratesAcquired($0)) }
                .subscribeOn(self._backgroundScheduler)
        }
    }
}

