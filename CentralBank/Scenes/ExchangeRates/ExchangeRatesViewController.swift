//
//  ExchangeRatesViewController.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback
import RxOptional

class ExchangeRatesViewController: UIViewController, ViewType {
    
    var state: Driver<ExchangeRatesViewState>!
 
    func subscribe(to stateStore: AppStateStore) {
        
        // State
        state = stateStore
            .stateBus
            .map { $0.exchangeRates.viewState }
            .distinctUntilChanged()
    }
}
