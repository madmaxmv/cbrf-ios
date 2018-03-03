//
//  CentralBankAPI.swift
//  CentralBank
//
//  Created by Максим on 22/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol CentralBankService {
    
    func rates(on date: Date) -> Observable<DailyRates>
}

struct APIService: CentralBankService {
    
    func rates(on date: Date) -> Observable<DailyRates> {
        return Observable<DailyRates>
            .create { observer in
                MoyaProvider<CentralBankEndpoint>().request(.rates(date)) { result in
                    switch result {
                    case .success(let response):
                        let rates: DailyRates = XMLDecoder(data: response.data).decode()
                        observer.on(.next(rates))
                    case .failure(let error):
                        observer.on(.error(error))
                    }
                    observer.on(.completed)
                }
                return Disposables.create()
        }
    }
}

