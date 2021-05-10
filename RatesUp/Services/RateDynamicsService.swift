//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Combine
import Foundation

protocol RateDynamicsProvider {

    func dynamicsForCurrency(
        withID currencyID: String,
        dateRange: (from: Date, to: Date)
    ) -> AnyPublisher<RateDynamics, Error>
}

final class RateDynamicsService {

    private let apiService: DynamicsAPI
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    init(apiService: DynamicsAPI) {
        self.apiService = apiService
    }
}

extension RateDynamicsService: RateDynamicsProvider {

    func dynamicsForCurrency(
        withID currencyID: String,
        dateRange: (from: Date, to: Date)
    ) -> AnyPublisher<RateDynamics, Error> {
        apiService
            .send(request: DynamicsRequest(
                currencyID: currencyID,
                range: dateRange
            ))
            .map { self.mapResponse($0) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    private func mapResponse(_ response: DynamicsResponse) -> RateDynamics {
        RateDynamics(
            dynamics: response.dynamics.compactMap {
                guard
                    let date = dateFormatter.date(from: $0.date),
                    let value = Double($0.value.replacingOccurrences(of: ",", with: "."))
                else {
                    return nil
                }

                return RateDynamics.CurrencyValue(
                    date: date,
                    value: value,
                    originValue: $0.value
                )
            }
        )
    }
}
