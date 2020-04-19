//
//  RatesUpAPI.swift
//  RatesUp
//
//  Created by Максим on 22/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol RatesUpService {
    
    func rates(on date: Date) -> Observable<DailyRatesData>
}

struct APIService: RatesUpService {
    
    func rates(on date: Date) -> Observable<DailyRatesData> {
        return Observable<DailyRatesData>
            .create { observer in
                MoyaProvider<RatesUpEndpoint>().request(.rates(date)) { result in
                    switch result {
                    case .success(let response):
                        let rates: DailyRatesData = XMLDecoder(data: response.data).decode()
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

