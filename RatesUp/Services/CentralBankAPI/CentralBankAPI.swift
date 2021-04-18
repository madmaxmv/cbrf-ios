//
//  RatesUpAPI.swift
//  RatesUp
//
//  Created by Максим on 22/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Combine

protocol RatesUpService {

    func rates(on date: Date) -> Future<DailyRatesData, Error>
}

struct APIService: RatesUpService {
    
    func rates(on date: Date) -> Future<DailyRatesData, Error> {
        return Future { promise in
            MoyaProvider<RatesUpEndpoint>().request(.rates(date)) { result in
                switch result {
                case .success(let response):
                    let rates: DailyRatesData = XMLDecoder(data: response.data).decode()
                    promise(.success(rates))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}

