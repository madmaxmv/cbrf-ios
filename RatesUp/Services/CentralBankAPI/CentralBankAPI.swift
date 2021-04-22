//
//  RatesUpAPI.swift
//  RatesUp
//
//  Created by Максим on 22/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Combine
import Foundation
import XMLParsing

protocol RatesAPIService {

    func rates(on date: Date) -> AnyPublisher<RatesResponse, APIError>
}

final class CentralBankAPI: RatesAPIService {

    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }
}

extension CentralBankAPI {

    func rates(on date: Date) -> AnyPublisher<RatesResponse, APIError> {
        apiService.publisher(
            for: RatesRequest(date: date),
            using: XMLDecoder()
        )
    }
}

// MARK: - XMLDecoder + TopLevelDecoder
extension XMLDecoder: TopLevelDecoder {
    public typealias Input = Data
}
