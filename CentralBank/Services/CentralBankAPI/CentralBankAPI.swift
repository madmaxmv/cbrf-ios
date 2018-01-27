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
    
    func rates(on date: Date) -> Single<[RateAPIModel]>
}

struct APIService: CentralBankService {
    
    func rates(on date: Date) -> Single<[RateAPIModel]> {
        return Single<[RateAPIModel]>
            .create { single in
                MoyaProvider<CentralBankEndpoint>().request(.rates(date)) { result in
                    switch result {
                    case .success(let response):
                        let rates = XMLDecoder(data: response.data).decode()
                        single(.success(rates))
                    case .failure(let error):
                        single(.error(error))
                    }
                }
                return Disposables.create()
        }
    }
}

